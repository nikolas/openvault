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
    # TODO: When we think everything has been ingested correctly, do one last search
    # and replace this with a static data structure, like for WPNA.
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
  
    def show_wpna
      # If you need to regenerate this, here's the one-liner I used:
      # Each input line has the form "<slug>\t<name>": sequential repeats of name are combined.
      # perl -e '$last="";@slugs=();while(<>){chomp;($slug,$name)=split /\t/;if($last eq $name){push @slugs, $slug}else{$first = shift @slugs; @rest = map {qq<"$_">} @slugs;$rest = join ", ",@rest; print qq<      {name: "$last", first: "$first", rest: [$rest]},\n>;@slugs=($slug)};$last = $name}' ~/nukes.txt
      @interviews = [
        {name: "Aaron, David", first: "wpna-b6b301-interview-with-david-aaron-1986", rest: []},
        {name: "Abrahamson, James A.", first: "wpna-bdd52a-interview-with-james-abrahamson-1987", rest: []},
        {name: "Adelman, Kenneth L. (Kenneth Lee)", first: "wpna-2ab613-interview-with-kenneth-adelman-1987", rest: []},
        {name: "Adzhubei, Aleksei", first: "wpna-e15b25-interview-with-aleksei-adzhubei-1986", rest: []},
        {name: "Akram, A. I.", first: "wpna-b3f0ab-interview-with-a-i-akram-1987", rest: []},
        {name: "Alekseev, A. I. (Aleksandr Ivanovich)", first: "wpna-7dbe0d-interview-with-a-i-aleksandr-ivanovich-alekseev-1986", rest: []},
        {name: "Allen, Lew", first: "wpna-5b1752-interview-with-lew-allen-1987", rest: []},
        {name: "Allison, Royal Bertram", first: "wpna-4081c0-interview-with-royal-bertram-allison-1986", rest: []},
        {name: "Alpert, Arnie", first: "wpna-13a47e-interview-with-arnie-alpert-1987", rest: []},
        {name: "Alsop, Joseph", first: "wpna-c59632-interview-with-joseph-alsop-1986", rest: []},
        {name: "Anderson, George Whelan", first: "wpna-87e3f3-interview-with-george-anderson-1986", rest: []},
        {name: "Apel, Hans", first: "wpna-8d43a2-interview-with-hans-apel-1987", rest: []},
        {name: "Arbatov, Alekseĭ Georgievich", first: "wpna-cdb9c0-interview-with-alexei-arbatov-1987", rest: []},
        {name: "Arneson, Gordon", first: "wpna-c592af-interview-with-gordon-arneson-1986", rest: []},
        {name: "Aspin, Les", first: "wpna-3e216d-interview-with-les-aspin-1987", rest: []},
        {name: "Atkins, Marvin", first: "wpna-c2991f-interview-with-marvin-atkins-1987", rest: []},
        {name: "AuCoin, Les", first: "wpna-30af4c-interview-with-les-aucoin-1987", rest: []},
        {name: "Bahr, Egon", first: "wpna-571585-interview-with-egon-bahr-1987", rest: []},
        {name: "Ball, George", first: "wpna-667691-interview-with-george-ball-1986", rest: []},
        {name: "Banta, Charles", first: "wpna-f1af74-interview-with-charles-banta-1987", rest: []},
        {name: "Barletta, W. A. (William A.)", first: "wpna-d674de-interview-with-william-barletta-1987", rest: []},
        {name: "Batenin, Heli", first: "wpna-46c3a1-interview-with-heli-batenin-1987", rest: []},
        {name: "Baudissin, Wolf, Graf von", first: "wpna-4baaa8-interview-with-wolf-graf-von-baudissin-1986", rest: []},
        {name: "Berezhkov, V. M. (Valentin Mikhaĭlovich)", first: "wpna-893ff8-interview-with-valentin-berezhkov-1986-1", rest: ["wpna-64667d-interview-with-valentin-berezhkov-1986-2"]},
        {name: "Bethe, Hans A. (Hans Albrecht)", first: "wpna-76629a-interview-with-hans-bethe-1986-1", rest: ["wpna-fce143-interview-with-hans-bethe-1986-2"]},
        {name: "Bogachev, Vladimir", first: "wpna-a945f5-interview-with-vladimir-bogachev-1986", rest: []},
        {name: "Bovin, Aleksandr Evgenevich", first: "wpna-015ff1-interview-with-aleksandr-evgenevich-bovin-1986", rest: []},
        {name: "Bowie, Robert R. (Robert Richardson)", first: "wpna-e8fb47-interview-with-robert-bowie-1987", rest: ["wpna-c9ed7c-interview-with-robert-bowie-1986"]},
        {name: "Bradbury, Norris", first: "wpna-989522-interview-with-norris-bradbury-1986-1", rest: ["wpna-2931fd-interview-with-norris-bradbury-1986-2"]},
        {name: "Brown, Harold", first: "wpna-beb27d-interview-with-harold-brown-1987-1", rest: ["wpna-b80d68-interview-with-harold-brown-1987-2", "wpna-1a13a9-interview-with-harold-brown-1986"]},
        {name: "Brzezinski, Zbigniew", first: "wpna-c1c1d6-interview-with-zbigniew-brzezinski-1986", rest: ["wpna-5d5f7b-interview-with-zbigniew-brzezinski-1989"]},
        {name: "Bundy, McGeorge", first: "wpna-4b23b3-interview-with-mcgeorge-bundy-1986-1", rest: ["wpna-cc06d7-interview-with-mcgeorge-bundy-1986-2"]},
        {name: "Bunn, George", first: "wpna-ffebb0-interview-with-george-bunn-1986", rest: []},
        {name: "Burke, Kelly H.", first: "wpna-56b793-interview-with-kelly-burke-1987", rest: []},
        {name: "Burlatsky, Fedor Mikhaĭlovich", first: "wpna-52aa15-interview-with-fyoder-burlatsky-1987", rest: ["wpna-8aa01f-interview-with-fyoder-burlatsky-1986"]},
        {name: "Burt, Richard", first: "wpna-57c452-interview-with-richard-burt-1987", rest: []},
        {name: "Callaghan, James", first: "wpna-2077fa-interview-with-james-callaghan-1987", rest: []},
        {name: "Camm, General Frank", first: "wpna-e940e9-interview-with-frank-camm-1987", rest: []},
        {name: "Canavan, Gregory H.", first: "wpna-2e522c-interview-with-gregory-canavan-1987", rest: []},
        {name: "Carnesale, Albert", first: "wpna-c9c777-interview-with-albert-carnesale-1987", rest: ["wpna-5c9771-interview-with-albert-carnesale-1988"]},
        {name: "Carroll, Eugene", first: "wpna-305694-interview-with-eugene-carroll-1986", rest: []},
        {name: "Carter, Ashton B.", first: "wpna-0db4e0-interview-with-ashton-carter-1987-1", rest: ["wpna-9f4111-interview-with-ashton-carter-1987-2"]},
        {name: "Carter, Jimmy", first: "wpna-7645df-interview-with-jimmy-carter-1987", rest: []},
        {name: "Carver, Michael", first: "wpna-60f99c-interview-with-michael-carver-1987", rest: []},
        {name: "Casey, Aloysius G.", first: "wpna-eb410a-interview-with-aloysius-casey-1987", rest: []},
        {name: "Chalfont, Arthur Gwynne Jones, Baron", first: "wpna-b4a06b-interview-with-arthur-chalfont-1986", rest: []},
        {name: "Chayes, Abram", first: "wpna-f31f1c-interview-with-abram-chayes-1986", rest: []},
        {name: "Chayes, Antonia Handler", first: "wpna-d3d25b-interview-with-antonia-chayes-1987", rest: []},
        {name: "Chervov, N. F.", first: "wpna-3f20f6-interview-with-n-f-chervov-1986", rest: ["wpna-3f3c4c-interview-with-n-f-chervov-1987"]},
        {name: "Clifford, Clark M.", first: "wpna-93ccab-interview-with-clark-clifford-1986", rest: []},
        {name: "Clifton, Chester V. (Chester Victor)", first: "wpna-ccb7c9-interview-with-chester-clifton-1986", rest: []},
        {name: "Cline, Ray S.", first: "wpna-c57d8b-interview-with-ray-cline-1986-1", rest: ["wpna-28a138-interview-with-ray-cline-1986-2"]},
        {name: "Cousins, Norman", first: "wpna-29cf83-interview-with-norman-cousins-1986-1", rest: ["wpna-aaf4b4-interview-with-norman-cousins-1986-2"]},
        {name: "Coyle, John Patterson", first: "wpna-0b7639-interview-with-john-coyle-1986", rest: []},
        {name: "Cross, Kenneth", first: "wpna-53f214-interview-with-kenneth-cross-1986", rest: []},
        {name: "Daniel, Jean", first: "wpna-366200-interview-with-jean-daniel-1986", rest: []},
        {name: "Davis, Lynn E. (Lynn Etheridge)", first: "wpna-14b15a-interview-with-lynn-davis-1987", rest: []},
        {name: "Davydov, Yuri Nikolaevich", first: "wpna-c73e6b-interview-with-yuri-davydov-1986", rest: []},
        {name: "Desai, Morarji", first: "wpna-64b58c-interview-with-morarji-desai-1987", rest: []},
        {name: "Deutch, John M.", first: "wpna-0ff772-interview-with-john-deutch-1987", rest: []},
        {name: "Dicks, Norman D.", first: "wpna-34f23b-interview-with-norman-dicks-1987", rest: []},
        {name: "Dougherty, Russell E.", first: "wpna-5f1ef2-interview-with-russell-dougherty-1987", rest: ["wpna-14fe68-interview-with-russell-dougherty-1986"]},
        {name: "Drell, Sidney D. (Sidney David)", first: "wpna-5452e6-interview-with-sidney-drell-1987", rest: ["wpna-c57c81-interview-with-sidney-drell-1986"]},
        {name: "Dubey, Muchkund", first: "wpna-322e1b-interview-with-muchkund-dubey-1987", rest: []},
        {name: "Dutson, Susan B.", first: "wpna-e301eb-interview-with-susan-dutson-1987", rest: []},
        {name: "Eisenhower, John S. D.", first: "wpna-284d36-interview-with-john-eisenhower-1986", rest: []},
        {name: "Enthoven, Alain C.", first: "wpna-92aaee-interview-with-alain-enthoven-1986", rest: []},
        {name: "Fairbourn, William T.", first: "wpna-9eca0f-interview-with-william-fairbourn-1986", rest: []},
        {name: "Falin, Valentin", first: "wpna-507fde-interview-with-valentin-falin-1986-1", rest: ["wpna-e725b5-interview-with-valentin-falin-1986-2", "wpna-8ce255-interview-with-valentin-falin-1987"]},
        {name: "Farley, Frances", first: "wpna-3a1bb3-interview-with-frances-farley-1987", rest: []},
        {name: "Farley, Philip J.", first: "wpna-063bbd-interview-with-philip-farley-1986", rest: []},
        {name: "Farrar-Hockley, Anthony", first: "wpna-2b57fb-interview-with-anthony-farrar-hockley-1987", rest: []},
        {name: "Feld, Bernard Taub", first: "wpna-bf4db1-interview-with-bernard-feld-1986", rest: []},
        {name: "Firmage, Edwin", first: "wpna-553fc4-interview-with-edwin-firmage-1987", rest: []},
        {name: "Forsberg, Randall", first: "wpna-0b5c8d-interview-with-randall-forsberg-1987", rest: ["wpna-926e36-interview-with-randall-forsberg-1988"]},
        {name: "Foster, John S.", first: "wpna-adf447-interview-with-john-foster-1987", rest: []},
        {name: "Frank, Barney", first: "wpna-cb91c7-interview-with-barney-frank-1987", rest: []},
        {name: "Freier, Shalheveth", first: "wpna-807053-interview-with-shalheveth-freier-1987", rest: []},
        {name: "Fukuda, Takeo", first: "wpna-f8c667-interview-with-takeo-fukuda-1987", rest: []},
        {name: "Fulbright, J. William (James William)", first: "wpna-511dd5-interview-with-james-fulbright-1986", rest: []},
        {name: "Gale, Larry", first: "wpna-8eab65-interview-with-larry-gale-1987", rest: []},
        {name: "Gallois, Pierre M. (Pierre Marie)", first: "wpna-b60a0b-interview-with-pierre-m-gallois-1986", rest: []},
        {name: "Garland, Cecil", first: "wpna-bb89b7-interview-with-cecil-garland-1987", rest: []},
        {name: "Garn, Senator Jake", first: "wpna-793691-interview-with-jake-garn-1987", rest: []},
        {name: "Garthoff, Raymond L.", first: "wpna-7d4acb-interview-with-raymond-garthoff-1986", rest: []},
        {name: "Garwin, Richard L.", first: "wpna-bb79eb-interview-with-richard-garwin-1987", rest: []},
        {name: "Gavin, James M. (James Maurice)", first: "wpna-ee2fae-interview-with-james-gavin-1986", rest: []},
        {name: "Gelb, Leslie H.", first: "wpna-35670b-interview-with-leslie-gelb-1987", rest: []},
        {name: "Gerasimov, Gennady", first: "wpna-0172f4-interview-with-gennady-gerasimov-1987", rest: []},
        {name: "Gilpatric, Roswell L. (Roswell Leavitt)", first: "wpna-828b0c-interview-with-roswell-gilpatric-1986-1", rest: ["wpna-3f24fc-interview-with-roswell-gilpatric-1986-2", "wpna-5c1293-interview-with-roswell-gilpatric-1986-3"]},
        {name: "Golden, William T.", first: "wpna-676002-interview-with-william-golden-1986", rest: []},
        {name: "Goldschmidt, Bertrand", first: "wpna-f3303e-interview-with-bertrand-goldschmidt-1986-1", rest: ["wpna-979ad6-interview-with-bertrand-goldschmidt-1986-2", "wpna-6193d9-interview-with-bertrand-goldschmidt-1986-3"]},
        {name: "Goodpaster, General Andrew", first: "wpna-b37adc-interview-with-andrew-goodpaster-1986-1", rest: ["wpna-f3aa17-interview-with-andrew-goodpaster-1986-2"]},
        {name: "Graybeal, Sidney", first: "wpna-f9acf2-interview-with-sidney-graybeal-1986", rest: []},
        {name: "Grewe, Wilhelm Georg", first: "wpna-91959a-interview-with-wilhelm-grewe-1986", rest: []},
        {name: "Gromyko, Andreĭ Andreevich", first: "wpna-f5ff2d-interview-with-andrei-gromyko-1988", rest: []},
        {name: "Gujral, I. K. (Inder Kumar)", first: "wpna-ef8c5d-interview-with-inder-gujral-1987", rest: []},
        {name: "Gur, Mordekhai", first: "wpna-93f62c-interview-with-mordekhai-gur-1987", rest: []},
        {name: "Han, Xu", first: "wpna-5c9b5a-interview-with-xu-han-1987", rest: []},
        {name: "Healey, Denis", first: "wpna-e3fddb-interview-with-denis-healey-1987", rest: ["wpna-32d67c-interview-with-denis-healey-1986"]},
        {name: "Helms, Richard", first: "wpna-e5183a-interview-with-richard-helms-1986", rest: []},
        {name: "Heseltine, Michael", first: "wpna-8b36be-interview-with-michael-heseltine-1987", rest: []},
        {name: "Hilsman, Roger", first: "wpna-00c001-interview-with-roger-hilsman-1986", rest: []},
        {name: "Hockaday, Arthur", first: "wpna-643a24-interview-with-arthur-hockaday-1987", rest: []},
        {name: "Hottelet, Richard C.", first: "wpna-e052ae-interview-with-richard-hottelet-1986", rest: []},
        {name: "Hunt, Kenneth", first: "wpna-1f3422-interview-with-kenneth-hunt-1986", rest: []},
        {name: "Iklé, Fred Charles", first: "wpna-dd8d21-interview-with-fred-ikle-1987-1", rest: ["wpna-212133-interview-with-fred-ikle-1987-2"]},
        {name: "Imai, Ryūkichi", first: "wpna-738238-interview-with-ryukichi-imai-1987", rest: []},
        {name: "Ishibashi, Masashi", first: "wpna-0be7f6-interview-with-masashi-ishibashi-1987", rest: []},
        {name: "Izakov, Boris", first: "wpna-ad14a3-interview-with-boris-izakov-1986", rest: []},
        {name: "Jha, C. S. (Chandra Shekhar)", first: "wpna-d38478-interview-with-c-s-chandra-shekhar-jha-1987", rest: []},
        {name: "Jha, Lakshmi Kant", first: "wpna-42ea0d-interview-with-lakshmi-jha-1987", rest: []},
        {name: "Joffe, Josef", first: "wpna-2627d9-interview-with-josef-joffe-1987", rest: []},
        {name: "Jones, David C.", first: "wpna-04a077-interview-with-david-jones-1986-1", rest: ["wpna-dbf0a8-interview-with-david-jones-1986-2"]},
        {name: "Kapitsa, Sergeĭ Petrovich", first: "wpna-4ec6a0-interview-with-sergei-kapitsa-1986", rest: []},
        {name: "Kaufmann, William W.", first: "wpna-6d0fcf-interview-with-william-kaufmann-1986", rest: []},
        {name: "Kaysen, Carl", first: "wpna-e05d04-interview-with-carl-kaysen-1986-1", rest: ["wpna-88668f-interview-with-carl-kaysen-1986-2"]},
        {name: "Kehler, Randy", first: "wpna-801982-interview-with-randy-kehler-1987", rest: []},
        {name: "Kelly, Petra Karin", first: "wpna-200914-interview-with-petra-kelly-1986", rest: []},
        {name: "Kent, Bruce", first: "wpna-2224da-interview-with-bruce-kent-1987", rest: []},
        {name: "Kent, Glenn A.", first: "wpna-ed9570-interview-with-glenn-kent-1986-1", rest: ["wpna-91ecdb-interview-with-glenn-kent-1986-2"]},
        {name: "Keyworth, George A.", first: "wpna-c3a554-interview-with-george-keyworth-1987", rest: []},
        {name: "Khan, Munir Ahmad", first: "wpna-af633f-interview-with-munir-khan-1987", rest: []},
        {name: "Killian, James Rhyne", first: "wpna-61f8ef-interview-with-james-rhyne-killian-1986", rest: []},
        {name: "Kissinger, Henry", first: "wpna-3c957b-interview-with-henry-kissinger-1986", rest: []},
        {name: "Kokoshin, Andreĭ Afanasevich", first: "wpna-8ea62e-interview-with-andrei-kokoshin-1987-1", rest: ["wpna-230fa6-interview-with-andrei-kokoshin-1987-2"]},
        {name: "Krasulin, Alexsandr B.", first: "wpna-092d5e-interview-with-alexsandr-krasulin-1986", rest: []},
        {name: "Kratzer, Myron B.", first: "wpna-5a72cf-interview-with-myron-kratzer-1987", rest: []},
        {name: "Kurihara, Yuko", first: "wpna-f6c97b-interview-with-yuko-kurihara-1987", rest: []},
        {name: "La Rocque, Gene R. (Gene Robert)", first: "wpna-3900cb-interview-with-gene-r-larocque-1986", rest: []},
        {name: "Lanphier, Thomas", first: "wpna-4c510f-interview-with-thomas-lanphier-1986", rest: []},
        {name: "Leach, James", first: "wpna-8b3dec-interview-with-james-leach-1987", rest: []},
        {name: "Leavitt, Charles", first: "wpna-58e673-interview-with-charles-leavitt-1987", rest: []},
        {name: "Lebedev, Yuriy Vladimirovich", first: "wpna-29a5de-interview-with-yuriy-lebedev-1986", rest: ["wpna-1b9244-interview-with-yuriy-lebedev-1987"]},
        {name: "Gilpatric, Roswell L. (Roswell Leavitt)", first: "wpna-828b0c-interview-with-roswell-gilpatric-1986-1", rest: ["wpna-3f24fc-interview-with-roswell-gilpatric-1986-2", "wpna-5c1293-interview-with-roswell-gilpatric-1986-3"]},
        {name: "Lomeĭko, V. (Vladimir)", first: "wpna-d0d3de-interview-with-vladimir-lomeiko-1986", rest: []},
        {name: "Luft, Michael", first: "wpna-67b406-interview-with-michael-luft-and-jeff-robles-1987", rest: []},
        {name: "Lundahl, Art", first: "wpna-65f472-interview-with-art-lundahl-1986", rest: []},
        {name: "Lynn, Laurence E.", first: "wpna-217bc9-interview-with-laurence-lynn-1987", rest: []},
        {name: "Manley, John Henry", first: "wpna-8e4ea2-interview-with-john-manley-1986", rest: []},
        {name: "Martin, Glen", first: "wpna-9ad48e-interview-with-glen-martin-1986-1", rest: ["wpna-52f0b7-interview-with-glen-martin-1986-2"]},
        {name: "Mason, Ronald, A.", first: "wpna-736df2-interview-with-ronald-mason-1987", rest: []},
        {name: "Mavroules, Nicholas", first: "wpna-8dd04b-interview-with-nicholas-mavroules-1987", rest: []},
        {name: "Mawby, Michael", first: "wpna-fa63b8-interview-with-michael-mawby-1987", rest: []},
        {name: "May, Charles", first: "wpna-cb1cdf-interview-with-charles-may-1987", rest: []},
        {name: "McCone, John A. (John Alex)", first: "wpna-cc620f-interview-with-john-mccone-1986-1", rest: ["wpna-b3557c-interview-with-john-mccone-1986-2"]},
        {name: "McFarlane, Robert C.", first: "wpna-ac5c23-interview-with-robert-c-mcfarlane-1987", rest: []},
        {name: "McNamara, Robert S.", first: "wpna-27c3ba-interview-with-robert-mcnamara-1986-1", rest: ["wpna-5b55e7-interview-with-robert-mcnamara-1986-2", "wpna-f1e5fc-interview-with-robert-mcnamara-1986-3"]},
        {name: "Menon, M. G. K. (Mambillikalathil Govind Kumar)", first: "wpna-1bee12-interview-with-m-g-k-menon-1987", rest: []},
        {name: "Messmer, Pierre", first: "wpna-3067b6-interview-with-pierre-messmer-1986", rest: []},
        {name: "Milhstein, Moshe (Mikhail M)", first: "wpna-dbe497-interview-with-moshe-milhstein-1986-1", rest: ["wpna-38407e-interview-with-moshe-milhstein-1986-2"]},
        {name: "Miller, Gerry", first: "wpna-fba599-interview-with-gerry-miller-1986", rest: []},
        {name: "Moorer, Thomas H.", first: "wpna-63082a-interview-with-thomas-moorer-1986", rest: []},
        {name: "Mori, Kazuhisa", first: "wpna-fbba80-interview-with-kazuhisa-mori-1987", rest: []},
        {name: "Moritaki, Ichirō", first: "wpna-676d42-interview-with-ichiro-moritaki-1987", rest: []},
        {name: "Morrison, Philip", first: "wpna-89c651-interview-with-philip-morrison-1986-1", rest: ["wpna-986ed1-interview-with-philip-morrison-1986-2"]},
        {name: "Neeman, Yuval", first: "wpna-39304e-interview-with-yuval-neeman-1987", rest: []},
        {name: "Nichols, Kenneth D. (Kenneth David)", first: "wpna-48842a-interview-with-kenneth-nichols-1986-1", rest: ["wpna-c9c30a-interview-with-kenneth-nichols-1986-2", "wpna-b2867a-interview-with-kenneth-nichols-1986-3"]},
        {name: "Nitze, Paul H.", first: "wpna-f96d50-interview-with-paul-nitze-1987-1", rest: ["wpna-f2fbfa-interview-with-paul-h-nitze-1986-2", "wpna-bdf7a9-interview-with-paul-nitze-1988", "wpna-0bc01a-interview-with-paul-nitze-1987-2", "wpna-f2fbfa-interview-with-paul-h-nitze-1986-2", "wpna-2b8615-interview-with-paul-nitze-1986-3"]},
        {name: "Nye, Joseph S.", first: "wpna-fc0b07-interview-with-joseph-nye-1987", rest: []},
        {name: "Obukhov, A. M. (Aleksandr Mikhaĭlovich)", first: "wpna-cdcaba-interview-with-aleksandr-obukhov-1986", rest: []},
        {name: "Osterheld, Horst", first: "wpna-6faadb-interview-with-horst-osterheld-1986", rest: []},
        {name: "Ota, Hiroshi", first: "wpna-58470c-interview-with-hiroshi-ota-1987", rest: []},
        {name: "Owen, David", first: "wpna-179431-interview-with-david-owen-1987", rest: []},
        {name: "Packard, David", first: "wpna-8d3ce9-interview-with-david-packard-1986", rest: []},
        {name: "Panofsky, Wolfgang K. H. (Wolfgang Kurt Hermann)", first: "wpna-36c89c-interview-with-wolfgang-panofsky-1986", rest: []},
        {name: "Peierls, Rudolf E. (Rudolf Ernst)", first: "wpna-90c242-interview-with-rudolf-peierls-1986", rest: []},
        {name: "Peled, Matityahu", first: "wpna-9159b6-interview-with-matityahu-peled-1987", rest: []},
        {name: "Perle, Richard Norman", first: "wpna-01c070-interview-with-richard-perle-1987-1", rest: ["wpna-e462d3-interview-with-richard-perle-1987-2", "wpna-71c560-interview-with-richard-perle-1987-3", "wpna-f03bb6-interview-with-richard-perle-1988"]},
        {name: "Perry, William James", first: "wpna-b75dbc-interview-with-william-perry-1987", rest: []},
        {name: "Petrovsky, Vladimir", first: "wpna-0d1cd6-interview-with-vladimir-petrovsky-1986", rest: ["wpna-70ac68-interview-with-vladimir-petrovsky-1987"]},
        {name: "Piadyshev, Boris Dmitrievich", first: "wpna-522414-interview-with-boris-d-pyadyshev-1986", rest: []},
        {name: "Pipes, Richard", first: "wpna-6ee0a5-interview-with-richard-pipes-1987", rest: ["wpna-446d06-interview-with-richard-pipes-1986"]},
        {name: "Policknov, Sergei", first: "wpna-6785fa-interview-with-sergei-policknov-1986-1", rest: ["wpna-eaf04c-interview-with-sergei-policknov-1986-2"]},
        {name: "Powell, Richard", first: "wpna-925b29-interview-with-richard-powell-1986", rest: []},
        {name: "Powers, David F. (David Francis)", first: "wpna-2dd6c2-interview-with-david-powers-1986", rest: []},
        {name: "Rabi, I. I. (Isidor Isaac)", first: "wpna-bccc37-interview-with-i-i-isidor-isaac-rabi-1986", rest: []},
        {name: "Rabin, Yitzhak", first: "wpna-e0bad9-interview-with-yitzhak-rabin-1987", rest: []},
        {name: "Ramanna, Raja", first: "wpna-38095d-interview-with-raja-ramanna-1987", rest: []},
        {name: "Raskin, Marcus G.", first: "wpna-cd4a07-interview-with-marcus-raskin-1986", rest: []},
        {name: "Rathjens, George", first: "wpna-dc15a2-interview-with-george-rathjens-1986", rest: []},
        {name: "Rauschenbach, Boris", first: "wpna-9da085-interview-with-boris-rauschenbach-1986", rest: []},
        {name: "Richardson, Robert C", first: "wpna-72cf78-interview-with-robert-c-richardson-1986", rest: []},
        {name: "Rickett, Denis", first: "wpna-a3b091-interview-with-denis-rickett-1986", rest: []},
        {name: "Roberts, Chalmers M. (Chalmers McGeagh)", first: "wpna-c7d51c-interview-with-chalmers-roberts-1986", rest: []},
        {name: "Roberts, Frank, Sir", first: "wpna-3b1a34-interview-with-frank-roberts-1986-1", rest: []},
        {name: "Roberts, Frank, Sir[2]", first: "wpna-28b077-interview-with-frank-roberts-1986-2", rest: []},
        {name: "Robles, Jeff", first: "wpna-67b406-interview-with-michael-luft-and-jeff-robles-1987", rest: []},
        {name: "Rose, François de", first: "wpna-7b76d5-interview-with-francois-de-rose-1986", rest: []},
        {name: "Roshin, Alexei", first: "wpna-d94413-interview-with-alexei-roshin-1986", rest: []},
        {name: "Rostow, Eugene V. (Eugene Victor)", first: "wpna-adf1a7-interview-with-eugene-rostow-1986", rest: []},
        {name: "Rotblat, Joseph", first: "wpna-db6dc9-interview-with-joseph-rotblat-1986", rest: []},
        {name: "Rowen, Henry S.", first: "wpna-5ee961-interview-with-henry-rowen-1986", rest: []},
        {name: "Rowny, Edward L.", first: "wpna-918401-interview-with-edward-l-rowny-1986-1", rest: ["wpna-39527e-interview-with-edward-l-rowny-1986-2"]},
        {name: "Rühl, Lothar", first: "wpna-7b106f-interview-with-lothar-ruhl-1987", rest: []},
        {name: "Ruina, J. P. (Jack P.)", first: "wpna-ed21dc-interview-with-jack-ruina-1986", rest: []},
        {name: "Rusk, Dean", first: "wpna-316d61-interview-with-dean-rusk-1986", rest: ["wpna-30518a-interview-with-dean-rusk-1988"]},
        {name: "Sagdeev, R. Z. (Roald)", first: "wpna-557267-interview-with-roald-sagdeev-1986", rest: ["wpna-1c06c8-interview-with-roald-sagdeev-1987"]},
        {name: "Salam, Abdus", first: "wpna-9b2f55-interview-with-abdus-salam-1986", rest: []},
        {name: "Sasaki, Kiyomi", first: "wpna-c200bf-interview-with-kiyomi-sasaki-1987", rest: []},
        {name: "Sattar, Abdul", first: "wpna-0efabf-interview-with-abdul-sattar-1987", rest: []},
        {name: "Scali, John", first: "wpna-326835-interview-with-john-scali-1986", rest: []},
        {name: "Schelling, Thomas C.", first: "wpna-ebd606-interview-with-thomas-schelling-1986", rest: []},
        {name: "Schlesinger, Arthur", first: "wpna-e7fe88-interview-with-arthur-schlesinger-1986", rest: []},
        {name: "Schlesinger, James R.", first: "wpna-62cc98-interview-with-james-schlesinger-1987-1", rest: ["wpna-ec43ef-interview-with-james-schlesinger-1987-2", "wpna-1bca5f-interview-with-james-schlesinger-1988"]},
        {name: "Schmidt, Helmut", first: "wpna-986edb-interview-with-helmut-schmidt-1987", rest: []},
        {name: "Schmückle, Gerd", first: "wpna-2f1a8a-interview-with-gerd-schmuckle-1986", rest: []},
        {name: "Schumann, Maurice", first: "wpna-1ad803-interview-with-maurice-schumann-1986-1", rest: ["wpna-50c784-interview-with-maurice-schumann-1986-2"]},
        {name: "Scowcroft, Brent", first: "wpna-851be0-interview-with-brent-scowcroft-1987", rest: []},
        {name: "Seaborg, Glenn T. (Glenn Theodore)", first: "wpna-e0bd60-interview-with-glenn-seaborg-1986", rest: []},
        {name: "Séguy, Georges", first: "wpna-0dcbc7-interview-with-georges-seguy-1986", rest: []},
        {name: "Semenov, V. S. (Vladimir Semyonovich)", first: "wpna-86b9eb-interview-with-vladimir-semyonovich-semyonov-1986", rest: []},
        {name: "Sethna, Homi", first: "wpna-574ece-interview-with-homi-sethna-1987", rest: []},
        {name: "Shahi, Agha", first: "wpna-a5d6e4-interview-with-agha-shahi-1987", rest: []},
        {name: "Shakhnazarov, Georgiĭ Khosroevich", first: "wpna-7d7712-interview-with-georgi-shakhnazarov-1987", rest: []},
        {name: "Sherfield, Roger Mellor Makins, Baron", first: "wpna-6b9e3f-interview-with-roger-sherfield-1986-1", rest: ["wpna-7b8ed5-interview-with-roger-sherfield-1986-2", "wpna-dd1c12-interview-with-roger-sherfield-1986-3", "wpna-c2aa4c-interview-with-roger-sherfield-1986-4"]},
        {name: "Shevchenko, Arkady N.", first: "wpna-bace25-interview-with-arkady-shevchenko-1986", rest: []},
        {name: "Shulman, Marshall Darrow", first: "wpna-8e1c88-interview-with-marshall-shulman-1986", rest: []},
        {name: "Shultz, George Pratt", first: "wpna-626a3d-interview-with-george-shultz-1986", rest: []},
        {name: "Simons, Thomas", first: "wpna-457ce2-interview-with-thomas-simons-1986", rest: []},
        {name: "Smith, Larry", first: "wpna-72f835-interview-with-larry-smith-1987", rest: []},
        {name: "Smith, Gerard C.", first: "wpna-10222c-interview-with-gerard-smith-1986", rest: []},
        {name: "Smith, William Y.", first: "wpna-d328ba-interview-with-william-smith-1987", rest: []},
        {name: "Soper, Donald", first: "wpna-69f07a-interview-with-donald-soper-1986", rest: []},
        {name: "Sorensen, Theodore C.", first: "wpna-1bee41-interview-with-theodore-sorensen-1986-1", rest: ["wpna-5d3c7b-interview-with-theodore-sorensen-1986-2"]},
        {name: "Sprague, Robert", first: "wpna-dfe326-interview-with-robert-sprague-1986", rest: []},
        {name: "Stoertz, Howard", first: "wpna-3f8ca0-interview-with-howard-stoertz-1986", rest: []},
        {name: "Subramanvam, Kandury", first: "wpna-396e86-interview-with-kandury-subramanvam-1987", rest: []},
        {name: "Swamy, Subramanian", first: "wpna-d50f4a-interview-with-subramanian-swamy-1987", rest: []},
        {name: "Takahashi, Akihiro", first: "wpna-dc7861-interview-with-akihiro-takahashi-1987", rest: []},
        {name: "Tatu, Michel", first: "wpna-5a87a3-interview-with-michel-tatu-1986-1", rest: ["wpna-690a9d-interview-with-michel-tatu-1986-2"]},
        {name: "Teller, Edward", first: "wpna-06c915-interview-with-edward-teller-1987", rest: ["wpna-c0523e-interview-with-edward-teller-1986"]},
        {name: "Thompson, E. P. (Edward Palmer)", first: "wpna-5d8952-interview-with-edward-palmer-thompson-1987", rest: []},
        {name: "Thomson, James, A.", first: "wpna-447797-interview-with-james-thomson-1989", rest: []},
        {name: "Timerbaev, R. M. (Roland Makhmutovich)", first: "wpna-530c01-interview-with-roland-timerbaev-1986-1", rest: ["wpna-a5204e-interview-with-roland-timerbaev-1986-2"]},
        {name: "Todenhöfer, Jürgen", first: "wpna-0e1282-interview-with-jurgen-todenhofer-1986", rest: []},
        {name: "Toomay, John", first: "wpna-0cf6f8-interview-with-john-toomay-1987", rest: []},
        {name: "Townes, Charles H.", first: "wpna-753147-interview-with-charles-h-townes-1987", rest: []},
        {name: "Trofimenko, G. A. (Genrikh Aleksandrovich)", first: "wpna-9c024e-interview-with-henry-genrikh-aleksandrovich-trofimenko-1986", rest: ["wpna-3644c1-interview-with-henry-genrikh-aleksandrovich-trofimenko-1987"]},
        {name: "Turner, Stansfield", first: "wpna-891ad7-interview-with-stansfield-turner-1987", rest: []},
        {name: "Usmani, Ishrat Husain", first: "wpna-d4db82-interview-with-ishrat-husain-usmani-1986", rest: []},
        {name: "Van Cleave, William R.", first: "wpna-b74299-interview-with-william-van-cleave-1987", rest: []},
        {name: "Vance, Cyrus R. (Cyrus Roberts)", first: "wpna-40d84c-interview-with-cyrus-vance-1987", rest: []},
        {name: "Velikhov, E. P.", first: "wpna-ba44a9-interview-with-evgeny-velikhov-1986", rest: []},
        {name: "Volpe, Joseph", first: "wpna-d816fc-interview-with-joseph-volpe-1986-1", rest: ["wpna-bf312b-interview-with-joseph-volpe-1986-2"]},
        {name: "Waller, Douglas C.", first: "wpna-ea9b0e-interview-with-douglas-waller-1987", rest: []},
        {name: "Walquist, Robert", first: "wpna-a54619-interview-with-robert-walquist-1987", rest: []},
        {name: "Warnke, Paul C.", first: "wpna-83c508-interview-with-paul-warnke-1986", rest: []},
        {name: "Watkins, James D.", first: "wpna-29ab2a-interview-with-james-watkins-1987", rest: []},
        {name: "Weinberger, Caspar W.", first: "wpna-7f992c-interview-with-caspar-weinberger-1987-1", rest: ["wpna-36e5bf-interview-with-caspar-weinberger-1987-2"]},
        {name: "Weisskopf, Victor Frederick", first: "wpna-79e5dd-interview-with-victor-weisskopf-1986", rest: []},
        {name: "Weizsäcker, Carl Friedrich, Freiherr von", first: "wpna-05c5f2-interview-with-carl-von-weizsacker-1986", rest: []},
        {name: "Wertheimer, Fred", first: "wpna-c6c9df-interview-with-fred-wertheimer-1987", rest: []},
        {name: "Wiesner, Jerome B. (Jerome Bert)", first: "wpna-9e6621-interview-with-jerome-wiesner-1986-1", rest: ["wpna-08512c-interview-with-jerome-wiesner-1986-2", "wpna-57178a-interview-with-jerome-wiesner-1986-3"]},
        {name: "Wilson, Pete", first: "wpna-a1af65-interview-with-pete-wilson-1987", rest: []},
        {name: "Wohlstetter, Albert J.", first: "wpna-6184b7-interview-with-albert-wohlstetter-1986", rest: []},
        {name: "Woolsey, R. James", first: "wpna-690ddc-interview-with-james-woolsey-1987", rest: []},
        {name: "York, Herbert F. (Herbert Frank)", first: "wpna-fc7f73-interview-with-herbert-york-1986", rest: ["wpna-f3068a-interview-with-herbert-york-1988"]},
        {name: "Zhurkin, Vitaliy Vladimirovich", first: "wpna-e93072-interview-with-vitaliy-vladimirovich-zhurkin-1986", rest: ["wpna-63cfaa-interview-with-vitaliy-vladimirovich-zhurkin-1987"]}  
      ]
    render file: 'override/catalog/wpna-wpna-war-and-peace-in-the-nuclear-age.html.erb'
  end
  
  def self.first_rest_list(names_blob)
    names_blob.split("\n").map do |name|
      name.strip!
      # TODO: maybe just search the title?
      # TODO: quote the part after the colon?
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
