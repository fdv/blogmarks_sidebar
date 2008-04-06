class BlogmarksSidebar < Sidebar
  display_name "Blogmarks"
  description 'Bookmarks from <a href="http://blogmarks.net">Blogmarks</a>'

  setting :feed, nil, :label => 'Feed URL'
  setting :count, 10, :label => 'Items Limit'
  setting :groupdate,   false, :input_type => :checkbox, :label => 'Group links by day'
  setting :description, false, :input_type => :checkbox, :label => 'Show description'
  setting :desclink,    false, :input_type => :checkbox, :label => 'Allow links in description'

  lifetime 1.hour

  def blogmarks
    @blogmarks ||= Blogmarks.new(feed) rescue nil
  end

  def parse_request(contents, params)
    return unless blogmarks

    if groupdate
      @blogmarks.days = {}
      @blogmarks.items.each_with_index do |d,i|
        break if i >= count.to_i
        index = d.date.strftime("%Y-%m-%d").to_sym
        (@blogmarks.days[index] ||= []) << d
      end
      @blogmarks.days =
        @blogmarks.days.sort_by { |d| d.to_s }.reverse.collect do |d|
        {:container => d.last, :date => d.first}
      end
    else
      @blogmarks.items = @blogmarks.items.slice(0, count.to_i)
    end
  end
end
