require 'yaml'
require 'front_matter_parser'
require 'engtagger'
require 'active_support/core_ext/string/inflections'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

namespace :auto do
  desc 'Suggest or apply tags/categories to posts from content. Set APPLY=true to write changes.'
  task :taxonomies do
    apply = ENV['APPLY'] == 'true'
    changed_only = ENV['CHANGED_ONLY'] == 'true'

    taxonomy = YAML.load_file(File.join('_data', 'taxonomy.yml'))
    vocabulary = Array(taxonomy['vocabulary']).map { |t| t.to_s.strip.downcase }
    synonyms = (taxonomy['synonyms'] || {}).transform_keys { |k| k.to_s.strip.downcase }
    tag_to_category = taxonomy['tag_to_category'] || {}
    max_tags = (taxonomy['max_tags'] || 5).to_i
    min_score = (taxonomy['min_score'] || 0.2).to_f

    posts = Dir.glob(File.join('_posts', '**', '*.md'))
    if changed_only
      changed = `git diff --name-only --diff-filter=ACMR origin/HEAD... HEAD -- _posts/**/*.md`.split("\n")
      posts &= changed unless changed.empty?
    end

    tagger = EngTagger.new

    post_docs = {}

    posts.each do |path|
      raw_source = File.open(path, 'r:bom|utf-8', &:read)
      fm = FrontMatterParser::Parser.new(:md).call(raw_source)
      data = fm.front_matter || {}
      body = fm.content.to_s
      title = data['title'].to_s
      raw = [title, body].join(' ').downcase
      # keep hyphens/spaces alnum for matching
      normalized = raw.gsub(/[^a-z0-9\-\s]/, ' ')
      # Prefer nouns when available
      nouns_map = tagger.get_nouns(normalized) || {}
      nouns_text = nouns_map.keys.join(' ')
      text = nouns_text.empty? ? normalized : nouns_text
      post_docs[path] = { data: data, content: fm.content, text: text }
    end

    diffs = []

    post_docs.each do |path, meta|
      text = meta[:text]
      scores = {}
      vocabulary.each do |tag|
        terms = [tag, tag.tr('-', ' ')] + synonyms.select { |k, v| v == tag }.keys
        occurrences = terms.sum do |term|
          phrase = Regexp.escape(term)
          pattern = /(?<![a-z0-9])#{phrase}(?![a-z0-9])/i
          text.scan(pattern).length
        end
        scores[tag] = occurrences.to_f
      end

      ranked = scores.select { |_, s| s >= min_score }.sort_by { |_, s| -s }.map(&:first).take(max_tags)

      # Normalize front matter
      current_tags = Array(post_docs[path][:data]['tags']).map { |t| t.to_s.strip.downcase }
      normalized = current_tags.map { |t| synonyms[t] || t }
      desired = (normalized + ranked).map { |t| t.strip.downcase }.uniq.sort

      # Categories from mapping
      current_cats = Array(post_docs[path][:data]['categories']).map(&:to_s)
      mapped_cats = desired.flat_map { |t| tag_to_category[t] }.compact.map(&:to_s).uniq
      desired_cats = (current_cats + mapped_cats).uniq

      if apply
        fm_data = post_docs[path][:data].dup
        fm_data['tags'] = desired
        fm_data['categories'] = desired_cats unless desired_cats.empty?
        new_yaml = fm_data.to_yaml.sub(/^---\s*$/,'---') + "\n"
        File.write(path, new_yaml + "\n" + post_docs[path][:content].to_s)
        puts "Updated: #{path} (tags: #{desired.join(', ')})"
      else
        if desired != current_tags || (mapped_cats - current_cats).any?
          diffs << "#{path}:\n  tags: #{current_tags} -> #{desired}\n  categories+: #{(mapped_cats - current_cats)}"
        end
      end
    end

    unless apply
      if diffs.empty?
        puts 'No suggestions; all posts already normalized.'
      else
        puts "Suggestions:\n\n" + diffs.join("\n")
        abort("auto:taxonomies suggestions differ. Run with APPLY=true to update.") if ENV['CI'] == 'true'
      end
    end
  end
end


