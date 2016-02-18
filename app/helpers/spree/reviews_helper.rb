module Spree::ReviewsHelper
  def star(the_class)
    content_tag(:span, ' &#10030; '.html_safe, class: the_class)
  end

  def icon_star(how_full)
    css_class = case how_full
      when :full
        "fa fa-star active"
      when :half
        "fa fa-star-half-empty"
      else
        "fa fa-star-empty"
      end
    content_tag(:i, "", class: css_class)
  end

  def mk_half_stars(rating)
    (1..Spree::Reviews::Config.stars).map do |n|
      n <= rating ? icon_star(:full) : (n <= rating + 0.5) ? icon_star(:half) : icon_star(:empty)
    end.join.html_safe
  end

  def mk_stars(m)
    (1..5).collect { |n| n <= m ? star('lit') : star('unlit') }.join
  end

  def txt_stars(n, show_out_of = true)
    res = Spree.t(:star, count: n)
    res += " #{Spree.t('out_of_5')}" if show_out_of
    res
  end
end
