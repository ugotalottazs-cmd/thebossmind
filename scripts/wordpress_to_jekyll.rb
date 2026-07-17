#!/usr/bin/env ruby

require 'nokogiri'
require 'fileutils'
require 'date'

class WordPressToJekyll
  def initialize(xml_file)
    @xml_file = xml_file
    @posts = []
    @categories = {}
    parse_xml
  end

  def parse_xml
    doc = Nokogiri::XML(File.read(@xml_file))
    
    # Define namespaces
    namespaces = {
      'wp' => 'http://wordpress.org/export/1.2/',
      'content' => 'http://purl.org/rss/1.0/modules/content/',
      'dc' => 'http://purl.org/dc/elements/1.1/'
    }

    # Extract posts
    doc.xpath('//item').each do |item|
      post_type = item.xpath('wp:post_type/text()', namespaces).to_s
      next unless post_type == 'post'

      status = item.xpath('wp:status/text()', namespaces).to_s
      next unless status == 'publish'

      post_data = {
        title: item.xpath('title/text()').to_s,
        content: item.xpath('content:encoded/text()', namespaces).to_s,
        author: item.xpath('dc:creator/text()', namespaces).to_s,
        date: item.xpath('pubDate/text()').to_s,
        post_id: item.xpath('wp:post_id/text()', namespaces).to_s,
        categories: extract_categories(item),
        tags: extract_tags(item),
        excerpt: item.xpath('wp:post_excerpt/text()', namespaces).to_s
      }

      @posts << post_data if post_data[:content].strip.length > 0
    end
  end

  def extract_categories(item)
    item.xpath('category[@domain="category"]/@nicename').map(&:to_s)
  end

  def extract_tags(item)
    item.xpath('category[@domain="post_tag"]/@nicename').map(&:to_s)
  end

  def create_jekyll_posts
    posts_dir = '_posts'
    FileUtils.mkdir_p(posts_dir) unless Dir.exist?(posts_dir)

    @posts.each do |post|
      date = parse_date(post[:date])
      filename = "#{date.strftime('%Y-%m-%d')}-#{sanitize_filename(post[:title])}.md"
      filepath = File.join(posts_dir, filename)

      frontmatter = {
        'layout' => 'post',
        'title' => post[:title],
        'date' => date.to_s,
        'author' => post[:author],
        'categories' => post[:categories],
        'tags' => post[:tags]
      }

      content = "---\n"
      frontmatter.each { |k, v| content += "#{k}: #{v.inspect}\n" }
      content += "---\n\n"
      content += post[:content]

      File.write(filepath, content)
      puts "Created: #{filepath}"
    end

    puts "\nTotal posts created: #{@posts.length}"
  end

  private

  def parse_date(date_string)
    DateTime.parse(date_string)
  rescue
    DateTime.now
  end

  def sanitize_filename(title)
    title
      .downcase
      .gsub(/[^\w\s-]/, '')
      .gsub(/\s+/, '-')
      .gsub(/-+/, '-')
      .gsub(/^-|-$/, '')
  end
end

# Main execution
if ARGV.empty?
  puts "Usage: ruby wordpress_to_jekyll.rb <xml_file>"
  exit 1
end

converter = WordPressToJekyll.new(ARGV[0])
converter.create_jekyll_posts
