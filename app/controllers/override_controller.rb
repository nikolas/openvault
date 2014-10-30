class OverrideController < ApplicationController  
  
  def show
    if params[:path] =~ /^[a-z0-9\/-]+$/i # paranoid about weird paths.
      override_file_path = "override/#{params[:path]}.html.erb"
      if File.exists?("app/views/#{override_file_path}")
        render file: override_file_path
        return
      end
    end
    render_404
  end
  
  def show_rock_and_roll
    @interviews = OverrideController.first_rest_list(<<-eof
      Allen, Hoss
      Arnold, Larkin
      Aronowitz, Al
      Atkins, Cholly
      Barry, Jeff
      Bartholomew, Dave
      Bayaan, Khalis
      Bell, Al
      Belolo, Henri
      Bono, Sonny
      Bowles, Beans
      Burlison, Paul
      Cecil, Malcolm
      Chess, Marshall
      Chess, Phil
      Clement, Jack
      Collins, Bootsy
      Dale, Dick
      Davis, Billy
      Dowd, Tom
      Eaton, J. M.
      Eli, Bobby
      Enrico, Greg
      Fontana, DJ
      Gamble, Kenny
      Gardner, Carl
      George, Nelson
      Graham, Larry
      Hall, Rick
      Hood, David
      Huff, Leon
      Janes, Roland
      Johnson, Jimmy
      Johnson, Johnnie
      King, Ben E.
      Kooper, Al
      LaBostrie, Dorothy
      Leiber, Jerry
      Levine, Larry
      Margouleff, Robert
      Martini, Jerry
      Matassa, Cosimo
      Medley, Bill
      Moore, Scotty
      Moulton, Tom
      Montana, Vince
      Oldham, Spooner
      Palmer, Earl
      Parker, Maceo
      Pendergrass, Teddy
      Phillinganes, Greg
      Phillips, Sam
      Powell, Maxine
      Price, Lloyd
      Reeves, Martha
      Robertson, Robbie
      Robinson, Claudette
      Robinson, Cynthia
      Starks, Jabo
      Stoller, Mike
      Stone, Fred
      Stone, Rose
      Tarsia, Joe
      Taylor, Derek
      Thomas, Rufus
      Turner, Ike
      Tyler, Red
      Wesley, Fred
      Westbrooks, Logan
      Wexler, Jerry
      Williams, Otis
      Worrell, Bernie
      Young, Earl
    eof
    )
    render file: 'override/catalog/roll-rock-and-roll.html.erb'
  end
  
  def self.first_rest_list(names_blob)
    names_blob.split("\n").map do |name|
      name.strip!
      # TODO: maybe just search the title?
      q = name.split(/,\s+/).map{|part|"text:#{part}"}.join(' ')
      slugs = (block_given? ? yield(q) : get_solr_ids(q)).grep /interview/
      slugs.sort_by!{|id|id.split('-').last}
      first = slugs[0]
      rest = slugs[1..slugs.length] || []
      {name: name, first: first, rest: rest}
    end.select{|name_slugs| name_slugs[:first]}
  end
  
  def self.get_solr_ids(q)
    Blacklight.solr.select(params: {q: q})['response']['docs'].map{|d|d['id']}
  end

end 
