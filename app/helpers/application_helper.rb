module ApplicationHelper

  def render_main_menu
    main_navigation = Storytime::Navigation.find_by(handle: "main")
    menu_html = if main_navigation
      render main_navigation
    else
      Storytime::Page.published.collect do |page|
        content_tag :li do
          link_to page.title, storytime.page_path(page)
        end
      end
    end
    if current_user&.admin?
      menu_html << content_tag(:li) do
        link_to t('defaults.admin'), storytime_admin_path
      end
    end
    menu_html.html_safe
  end

  def recent_posts
    Storytime::BlogPost.published.order(published_at: :desc).limit(3)
  end

  def current_page_slug
    @page&.slug
  end

  def header_colour
    # available colors: blue, azure, green, orange, red, purple, gray
    # use it with: "header header-filter parallax parallax-product parallax-#{color}"
    case current_page_slug
    when 'home'
      :green
    when 'blog'
      :red
    else
      :orange
    end
  end

  def page_title
    if @page
      case @page.slug
      when 'home'
        storytime_snippet("home_page_title")
      else
        @page&.title
      end
    elsif @post
      @post.title
    end
  end

  def post_primary_image_url(post)
    post&.featured_media&.file&.url
  end

  def post_secondary_image_url(post)
    post&.secondary_media&.file&.url
  end

  def post_primary_or_default_image_url(post)
    post_primary_image_url(post) || image_url('default_post_image_placeholder.svg')
  end

  def header_page_title_bg_style(post)
    if post_secondary_image_url(post)
      <<-EOS
      background-color: #f6b33c;
      background-image: url('#{post_secondary_image_url(@post)}'), linear-gradient(180deg, hsla(0, 0%, 100%, .25), hsla(0, 0%, 100%, 0)), -webkit-gradient(linear, left top, left bottom, from(#f6b33c), to(#f6b33c));
      background-image: url('#{post_secondary_image_url(@post)}'), linear-gradient(180deg, hsla(0, 0%, 100%, .25), hsla(0, 0%, 100%, 0)), linear-gradient(180deg, #f6b33c, #f6b33c);
      EOS
    else
      ''
    end
  end

  def blog_slug
    "/#{Storytime::Blog.find_by(title: 'Blog')&.slug}"
  end

  def tag_color(tag_name)
    case tag_name
    when 'presentation'
      :red
    when 'conference'
      :yellow
    when 'ruby'
      :green
    when 'EN'
      :brown
    when 'UA'
      :brown
    when 'RU'
      :brown
    else
      :default
    end
  end

end
