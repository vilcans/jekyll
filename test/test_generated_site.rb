require File.dirname(__FILE__) + '/helper'

class TestGeneratedSite < Test::Unit::TestCase
  def setup
    clear_dest
    source = File.join(File.dirname(__FILE__), *%w[source])
    @s = Site.new(source, dest_dir)
    @s.process
    @index = File.read(File.join(dest_dir, 'index.html'))
  end
  
  def test_site_posts_in_index
    # confirm that {{ site.posts }} is working
    puts @s.posts.size
    assert @index.include?("#{@s.posts.size} Posts")
  end

  def test_post_content_in_index
    # confirm that the {{ post.content }} is rendered OK
    assert @index.include?('<p>This <em>is</em> cool</p>')
  end

  def test_post_categories_in_category_test
    category_test = File.read(File.join(dest_dir, 'category_test.html'))
    assert category_test.include?('<div>foo</div>')
  end
end
