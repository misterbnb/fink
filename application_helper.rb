module ApplicationHelper
  def url_prefix
    I18n.locale.to_s == I18n.default_locale.to_s ? "" : "/#{I18n.locale}"
  end

  def date_format_for_js
    if I18n.locale.to_s == 'en'
      'mm/dd/yy'
    else
      'dd/mm/yy'
    end
  end

  def soft_clean(string_output)
    sanitize string_output, tags: %w(table tr td p h1 h2 h3 h4 span img ul li a iframe), attributes: %w(id class style with height href src frameborder allowfullscreen target name)
  end

  def hard_clean_with_truncate(string, length)
    truncate(strip_tags(string), length: length, escape: false)
  end

  def autocomplete_city(args)
    type = args[:autocomplete_type] ? args[:autocomplete_type] : 'City'

    if Rails.env == 'test'
      coords = "Paris::48.8566::2.35222" if Rails.env == 'test'
      name   = "Paris, France"
      js_action = "nothing"
    else
      if args[:value] && args[:value].is_a?(Location)
        name = if args[:value].country
                 "#{args[:value].name}, #{args[:value].country.name}"
               else
                 "#{args[:value].name}"
               end
        coords = "#{args[:value].name}::#{args[:value].lat}::#{args[:value].lng}"
      elsif
        name = args[:value]
        coords = ''
      else
        name = ''
        coords = ''
      end
      js_action = "autocomplete#{type}"
    end
    data = {name: args[:name], do: js_action, hidden: args[:name]}
    data.merge!(args[:data]) if args[:data]

    out = text_field_tag('addressinput', name, class: args[:class], placeholder: args[:placeholder], data: data, disabled: args[:disabled])
    out += text_field_tag(args[:name], coords, class: 'hide', data: {testing: "autocomplete#{type}"})

    return out.html_safe
  end

  def autocomplete_all(args)
    args[:autocomplete_type] = 'All'
    autocomplete_city(args)
  end

  def cl_default_options
    {quality: :auto, flags: :lossy, fetch_format: :auto}
  end

  def cl_image_path(source, options = {})
    super(source, cl_default_options.merge(options))
  end

  def cl_image_tag(source, options = {})
    if Rails.env.test?
      # Hackish way to use local fixtures images in DEV/TEST instead of calling out Cloudinary
      if source.to_s[0..24] == 'http://res.cloudinary.com'
        if source.model.illustrable_type == 'Hosting'
          "<img src='/fixtures/hosting.jpg' width='#{options[:width]}' height='#{options[:height]}' class='#{options[:class]}' alt='image' />".html_safe
        else
          "<img src='/fixtures/avatar.png' width='#{options[:width]}' height='#{options[:height]}' class='#{options[:class]}' alt='image' />".html_safe
        end
      else
        if File.exists?(File.join(Rails.root, 'app', 'assets', 'images', source.to_s ))
          "<img src='/assets/#{source.to_s}' class='#{options[:class]}' />".html_safe
        else
          "<img src='/fixtures/avatar.png' width='#{options[:width]}' height='#{options[:height]}' class='#{options[:class]}' class='#{options[:class]}' />".html_safe
        end
      end
    elsif options[:class] && options[:class].include?('lazyload') && LAZYLOAD[:enabled]
      options[:'data-src'] = cl_image_path(source, options)
      options[:src] = '/assets/lazyload_placeholder.jpg'
      super(false, cl_default_options.merge(options))
    else
      super(source, cl_default_options.merge(options))
    end
  end

  def rating_stars(score, editable = :no, bigger = false)
    out  = ""
    data_ratable = ''

    (1..5).each do |i|
      data_ratable = "data-rate='#{i}' " if editable == :ratable
      bigger == true ? big_star = "bigger" : big_star = ''

      out += "<i class='icon-mbnb star#{(' inactive' if i > score.to_i)} #{big_star}' #{data_ratable}></i>"
    end

    return out.html_safe
  end

  def to_currency(price)
    number_to_currency(price, locale: I18n.locale.to_sym, unit: $CURRENCY[:sign], precision: 0)
  end

  def set_js_session
    out  = "<script type='text/javascript'>"
    out += "I18n = {locale: '#{I18n.locale}', prefix: '#{url_prefix}', date_format: '#{date_format_for_js}'};"

    if current_user
      out += "CurrentUser = {id: '#{current_user.id}', avatar: '#{current_user.avatar}'};"
    else
      out += "CurrentUser = {id: null, avatar: null};"
    end
    # https://github.com/fnando/browser/issues/270
    out += "Device = {mobile: #{browser.device.mobile? ? true : false}, tablet: #{browser.device.tablet?}};"
    out += "</script>"

    return out.html_safe
  end

  def static_path(str)
    page = Page.published.where(['role = ?', str]).first

    page ? page_path(page.slug) : '#'
  end

  def locale_flag(locale)
    flag = locale.to_s
    flag = 'gb' if locale.to_s == 'en'

    image_tag "flags/flat/32/#{flag.upcase}.png", alt:"#{I18n.locale}"
  end

  def twitter_lnk
    'https://twitter.com/mister_bandb'
  end

  def facebook_lnk
    'https://www.facebook.com/misterbandb/'
  end

  def instagram_lnk
    'https://www.instagram.com/mister_bandb/'
  end

  def linkedin_lnk
    'https://www.linkedin.com/company/misterbandb'
  end

  def google_plus_lnk
    'https://plus.google.com/114083045610700351367'
  end

  def appstore_lnk
    'https://itunes.apple.com/us/app/misterb-b-gay-travel-accommodations/id731435608?mt=8'
  end

  def googleplay_lnk
    'https://play.google.com/store/apps/details?id=com.sfo84'
  end

  def zendesk_power_host_link
    'https://misterbandb.zendesk.com/hc/en-us/articles/115000586306'
  end

  def apps_url_for_platform
    if browser.platform.ios?
      appstore_lnk
    elsif browser.platform.android?
      googleplay_lnk
    else
      apps_path
    end
  end

  def certified_image_tag
    image_name = "certified_en.png"
    image_name = "certified_fr.png" if I18n.locale.to_s == 'fr'

    image_tag image_name, class: 'certified'
  end

  def banner_tag(banner, options = {})
    image = banner.image_file
    link = banner.link

    html_options = options.delete(:html_options) { {data: {is: 'banner-container'}, style: 'padding-bottom: 20px;'} }

    content = nil
    if image
      if link.blank?
        content = cl_image_tag(image, options)
      else
        content = link_to(cl_image_tag(image, options), link, target: '_blank')
      end
    end

    content_tag :div, content, html_options if content
  end

  def cookie_box(key, text)
    return if cookies["#{key}_consented"] == 'true'
    content = content_tag(:span, text, {class: 'cookie-box-content-holder col-sm-22'}, false)
    content += content_tag(:span, class: 'cookie-box-button-holder col-sm-2') do
      button_tag(t('cookies_eu.ok'), type: 'button', class: 'cookie-box-ok', data: {container: key})
    end

    content_tag(:div, content, class: "#{key} cookie-box row")
  end

  def engage_referral_showable?
    out = false
    if current_user
      excluded_paths = %w(/rooms/new /account/invites/new /login)
      unless excluded_paths.include?(request.path)
        out = true
      end
    end

    excluded_controllers = %w(registrations payment search)
    if excluded_controllers.include?(params[:controller])
      out = false
    end

    out = false if browser.device.mobile?

    return out
  end

  def engage_signup_showable?
    out = false
    if !current_user
      excluded_paths = %w(/rooms/new /account/invites/new /login)
      unless excluded_paths.include?(request.path)
        out = true
      end

      out = false if params[:controller] == 'payment'
      out = false if params[:controller] == 'registrations'
    end

    out = false if browser.platform.android? || browser.platform.ios?

    return out
  end

  def promote_app_showable?
    browser.platform.android? || browser.platform.ios?

    # disable promote popup
    false
  end

end
