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
      # If you need to regenerate this, here's the one-liner I. used:
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

  def show_vietnam
    @interviews = [
      {name: "Nguyen Thi Binh", first: "vietnam-1dbd9d-interview-with-nguyen-thi-binh-1981", rest: []},
      {name: "Michael J. Mike Connors", first: "vietnam-38a2e0-interview-with-michael-j-mike-connors-1981", rest: []},
      {name: "Leslie H. Gelb", first: "vietnam-48133e-interview-with-leslie-h-gelb-1982", rest: []},
      {name: "Dang Xuan Teo", first: "vietnam-d7c86f-interview-with-dang-xuan-teo-1981", rest: []},
      {name: "Lloyd M. Mike Rives", first: "vietnam-7cf4bd-interview-with-lloyd-m-mike-rives-1982", rest: []},
      {name: "Phillip Key", first: "vietnam-933ca3-interview-with-phillip-key-1981", rest: []},
      {name: "Young Vietnamese Boys", first: "vietnam-3271f3-interview-with-young-vietnamese-boys-1981", rest: []},
      {name: "William P. Bundy", first: "vietnam-0a7751-interview-with-william-p-bundy-1981", rest: []},
      {name: "Paul N. Mccloskey", first: "vietnam-834453-interview-with-paul-n-mccloskey-1981", rest: []},
      {name: "Archimedes L. A Patti", first: "vietnam-bf3262-interview-with-archimedes-l-a-patti-1981", rest: []},
      {name: "Ton That Tung", first: "vietnam-4798f7-interview-with-ton-that-tung-1981", rest: []},
      {name: "Nguyen Khanh", first: "vietnam-f2fe66-interview-with-nguyen-khanh-1981", rest: []},
      {name: "Chhang Song", first: "vietnam-57f60b-interview-with-chhang-song", rest: []},
      {name: "William Childs Westmoreland", first: "vietnam-b463a4-interview-with-william-c-william-childs-westmoreland-1981", rest: []},
      {name: "Clark M. Clifford", first: "vietnam-4bf800-interview-with-clark-m-clifford-1981", rest: []},
      {name: "Tran Thi Truyen", first: "vietnam-72c7c8-interview-with-tran-thi-truyen-1981", rest: []},
      {name: "Lucien Conein", first: "vietnam-3abc7d-interview-with-lucien-conein-1981", rest: []},
      {name: "Melvin R. Laird", first: "vietnam-e4f1a1-interview-with-melvin-r-laird-1981", rest: []},
      {name: "Nguyen Thi Te", first: "vietnam-e09f9c-interview-with-nguyen-thi-te-1981", rest: []},
      {name: "Wayne Smith", first: "vietnam-7e3834-interview-with-wayne-smith-1982", rest: []},
      {name: "Harry Mcpherson", first: "vietnam-000f9b-interview-with-harry-mcpherson-1981", rest: []},
      {name: "Jack Keegan", first: "vietnam-d12094-interview-with-jack-keegan-1981", rest: []},
      {name: "William R. Corson", first: "vietnam-0ab374-interview-with-william-r-corson-1982", rest: []},
      {name: "Hoang Phu Ngoc Tuong", first: "vietnam-3fe9ec-interview-with-hoang-phu-ngoc-tuong-1982", rest: []},
      {name: "George Christian", first: "vietnam-ec7509-interview-with-george-christian-1981", rest: []},
      {name: "Dao Vien Trung", first: "vietnam-d37bd9-interview-with-dao-vien-trung-1981", rest: []},
      {name: "Bill D. Moyers", first: "vietnam-369379-interview-with-bill-d-moyers-1981", rest: []},
      {name: "Ama Hoa", first: "vietnam-eb3c84-interview-with-ama-hoa-1981", rest: []},
      {name: "Abbott Low Moffat", first: "vietnam-8a2551-interview-with-abbott-low-moffat-1982", rest: []},
      {name: "Thu Van", first: "vietnam-ffee91-interview-with-thu-van-1981", rest: []},
      {name: "Jonathan F. Jonathan Fredric Ladd", first: "vietnam-b2ee43-interview-with-jonathan-f-jonathan-fredric-ladd-1982", rest: []},
      {name: "Ho Minh Sac", first: "vietnam-3e5493-interview-with-ho-minh-sac-1981", rest: []},
      {name: "Nguyen Phan Phuc", first: "vietnam-886616-interview-with-nguyen-phan-phuc-1981", rest: []},
      {name: "John D. Negroponte", first: "vietnam-1a818d-interview-with-john-d-negroponte-1981", rest: []},
      {name: "H. Bot Adrong", first: "vietnam-62611d-interview-with-h-bot-adrong-1981", rest: []},
      {name: "Jack Valenti", first: "vietnam-9ce4c1-interview-with-jack-valenti-1981", rest: []},
      {name: "Nguyen Thi Hoa", first: "vietnam-462be3-interview-with-nguyen-thi-hoa-1981", rest: []},
      {name: "Dang Van Son", first: "vietnam-dcc279-interview-with-dang-van-son-1981", rest: []},
      {name: "Chhit Do", first: "vietnam-9d1903-interview-with-chhit-do-1982", rest: []},
      {name: "Douglas Kinnard", first: "vietnam-f17174-interview-with-douglas-kinnard-1982", rest: []},
      {name: "William Sloane Coffin", first: "vietnam-35b1e5-interview-with-william-sloane-coffin-1982", rest: []},
      {name: "Pham Thi Xuan Que", first: "vietnam-9a446d-interview-with-pham-thi-xuan-que-1981", rest: []},
      {name: "Everett Bumgardner", first: "vietnam-7d0a90-interview-with-everett-bumgardner-1-1981",
        rest: ["vietnam-d6ffa3-interview-with-everett-bumgardner-2-1982"]
      },
      {name: "Vietnamese Museum Guide", first: "vietnam-c17403-interview-with-vietnamese-museum-guide-1981", rest: []},
      {name: "George W. Ball", first: "vietnam-5e228c-interview-with-george-w-ball-1981", rest: []},
      {name: "Richard M. Moose", first: "vietnam-b44658-interview-with-richard-m-moose-1981", rest: []},
      {name: "Nguyen Van Nghi", first: "vietnam-ef85e3-interview-with-nguyen-van-nghi-1981", rest: []},
      {name: "John Kerry", first: "vietnam-306cf2-interview-with-john-kerry-1982", rest: []},
      {name: "Eugene J. Mccarthy", first: "vietnam-dd4bf1-interview-with-eugene-j-mccarthy-1982", rest: []},
      {name: "Scott Camil", first: "vietnam-61becc-interview-with-scott-camil-1981", rest: []},
      {name: "Van Tien Dung", first: "vietnam-e78a5e-interview-with-van-tien-dung-1981", rest: []},
      {name: "Pham Van Dong", first: "vietnam-df9fbf-interview-with-pham-van-dong-1981", rest: []},
      {name: "Ngo Minh Khoi", first: "vietnam-53e733-interview-with-ngo-minh-khoi-1981", rest: []},
      {name: "Mrs Ngo Ba Thanh", first: "vietnam-0bb668-interview-with-mrs-ngo-ba-thanh-1981", rest: []},
      {name: "Vu Quoc Uy", first: "vietnam-d4ea0b-interview-with-vu-quoc-uy-1981", rest: []},
      {name: "Bayard Rustin", first: "vietnam-a3b1e1-interview-with-bayard-rustin-1982", rest: []},
      {name: "Jane Barton", first: "vietnam-af4a30-interview-with-jane-barton-1981", rest: []},
      {name: "Nguyen Luan", first: "vietnam-81880e-interview-with-nguyen-luan-1981", rest: []},
      {name: "Nguyen Huu Hanh", first: "vietnam-8289ff-interview-with-nguyen-huu-hanh-1981", rest: []},
      {name: "Hoang Loc", first: "vietnam-fd3529-interview-with-hoang-loc-1981", rest: []},
      {name: "L. Dean Brown", first: "vietnam-94361b-interview-with-l-dean-brown-1981", rest: []},
      {name: "Ngo Minh Kha", first: "vietnam-4e201a-interview-with-ngo-minh-kha-1981", rest: []},
      {name: "Huynh Van Tieng", first: "vietnam-774f8d-interview-with-huynh-van-tieng-1981", rest: []},
      {name: "J. Vinton Lawrence", first: "vietnam-fae359-interview-with-j-vinton-vint-lawrence-1981", rest: []},
      {name: "Frederick G. Dutton", first: "vietnam-478315-interview-with-frederick-g-dutton-1981", rest: []},
      {name: "Richard C. Holbrooke (part 2)", first: "vietnam-019ef6-interview-with-richard-c-holbrooke-2-1982", rest: []},
      {name: "Tran Duy Hung", first: "vietnam-1937cc-interview-with-tran-duy-hung-1981", rest: []},
      {name: "Jack Hill", first: "vietnam-cc6145-interview-with-jack-hill-1982", rest: []},
      {name: "Raymond K. Raymond Kissam Price", first: "vietnam-eb0026-interview-with-raymond-k-raymond-kissam-price-1982", rest: []},
      {name: "Paul M. Kattenburg", first: "vietnam-f47e46-interview-with-paul-m-kattenburg-1981", rest: []},
      {name: "Le Minh Dao", first: "vietnam-2ecd26-interview-with-le-minh-dao-1981", rest: []},
      {name: "George Cantero", first: "vietnam-52aad2-interview-with-george-cantero-1981", rest: []},
      {name: "Tuu Ky", first: "vietnam-2ab2d9-interview-with-tuu-ky-1981", rest: []},
      {name: "Nguyen Thi Nguyet Anh", first: "vietnam-ac000f-interview-with-nguyen-thi-nguyet-anh-1981", rest: []},
      {name: "Duong Van Khang", first: "vietnam-6adbe2-interview-with-duong-van-khang-1981", rest: []},
      {name: "Le Tran Nhan", first: "vietnam-c30e89-interview-with-le-tran-nhan-1981", rest: []},
      {name: "Sam Brown", first: "vietnam-5f3845-interview-with-sam-brown-1982", rest: []},
      {name: "Tran Van Nhut", first: "vietnam-5edaef-interview-with-tran-van-nhut-1981", rest: []},
      {name: "Hoang Thi Dan", first: "vietnam-1cdfee-interview-with-hoang-thi-dan-1981", rest: []},
      {name: "Nguyen Thi Mai", first: "vietnam-f8daaf-interview-with-nguyen-thi-mai-1981", rest: []},
      {name: "Madame Ngo Dinh Nhu", first: "vietnam-1a3f8e-interview-with-madame-ngo-dinh-nhu-1982", rest: []},
      {name: "Hoang Thi Thu", first: "vietnam-c4d87f-interview-with-hoang-thi-thu-1981", rest: []},
      {name: "Nguyen Manh Ai", first: "vietnam-5ac0b6-interview-with-nguyen-manh-ai-1981", rest: []},
      {name: "Douglas MacArthur", first: "vietnam-4ab69e-interview-with-douglas-macarthur-1982", rest: []},
      {name: "Ho Thanh Dam", first: "vietnam-1bca76-interview-with-ho-thanh-dam-1981", rest: []},
      {name: "Nguyen Van Binh", first: "vietnam-ffa41d-interview-with-nguyen-van-binh-1981", rest: []},
      {name: "Duong Long Sang", first: "vietnam-3203c6-interview-with-duong-long-sang-1981", rest: []},
      {name: "Robert J. Bobfranco", first: "vietnam-8a3c98-interview-with-robert-j-bob-franco", rest: []},
      {name: "Mcgeorgebundy", first: "vietnam-c224f2-interview-with-mcgeorge-bundy", rest: []},
      {name: "Frank Fred Hickey", first: "vietnam-b0f9b2-interview-with-frank-fred-hickey-1981", rest: []},
      {name: "William Egan Colby", first: "vietnam-4e3224-interview-with-william-egan-colby-1981", rest: []},
      {name: "Nguyen Huu Tho", first: "vietnam-3443d8-interview-with-nguyen-huu-tho-1981", rest: []},
      {name: "Nguyen Bay", first: "vietnam-9442ef-interview-with-nguyen-bay-1981", rest: []},
      {name: "Le Thi Ma", first: "vietnam-5f0a21-interview-with-le-thi-ma-1981", rest: []},
      {name: "Tran Thi My", first: "vietnam-0b2012-interview-with-tran-thi-my-1981", rest: []},
      {name: "Morton H. Halperin", first: "vietnam-386950-interview-with-morton-h-halperin-1981", rest: []},
      {name: "Tran Van Lai", first: "vietnam-767cb6-interview-with-tran-van-lai-1981", rest: []},
      {name: "Le Lam", first: "vietnam-e080e1-interview-with-le-lam-1981", rest: []},
      {name: "Do Cuong", first: "vietnam-470cbc-interview-with-do-cuong-1981", rest: []},
      {name: "Hoang Anh Tuan", first: "vietnam-a8155e-interview-with-hoang-anh-tuan-1981", rest: []},
      {name: "Doidge Estcourt Taunton", first: "vietnam-803ba6-interview-with-doidge-estcourt-taunton-1982", rest: []},
      {name: "Thomas H. Moorer", first: "vietnam-59ce8c-interview-with-thomas-h-moorer-1981", rest: []},
      {name: "Pierrebrochand", first: "vietnam-b73429-interview-with-pierre-brochand", rest: []},
      {name: "Kenneth Moorefield", first: "vietnam-c82024-interview-with-kenneth-moorefield-1981", rest: []},
      {name: "Nguyen Thi Sinh", first: "vietnam-1fe036-interview-with-nguyen-thi-sinh-1981", rest: []},
      {name: "Nguyen Huu Nhan", first: "vietnam-846229-interview-with-nguyen-huu-nhan-1981", rest: []},
      {name: "David T. Dellinger", first: "vietnam-6cba85-interview-with-david-t-dellinger-1982", rest: []},
      {name: "Nguyen Cong Thanh", first: "vietnam-34e4d9-interview-with-nguyen-cong-thanh-1981", rest: []},
      {name: "John Chancellor", first: "vietnam-f269d9-interview-with-john-chancellor-1982", rest: []},
      {name: "Peter Paulmahoney", first: "vietnam-13d816-interview-with-peter-paul-mahoney", rest: []},
      {name: "Le Thi Ton", first: "vietnam-6c549d-interview-with-le-thi-ton-1981", rest: []},
      {name: "Nguyen Si Que", first: "vietnam-4f16c1-interview-with-nguyen-si-que-1981", rest: []},
      {name: "Bui Diem", first: "vietnam-6ed7f9-interview-with-bui-diem-1-1981",
        rest: ["vietnam-3152dc-interview-with-bui-diem-2-1981"]
      },
      {name: "Hoang Duc Nha", first: "vietnam-35c9b1-interview-with-hoang-duc-nha-1-1981", rest: []},
      {name: "Nguyen Cao Ky", first: "vietnam-931335-interview-with-nguyen-cao-ky-1981", rest: []},
      {name: "Ray S. Cline", first: "vietnam-bbff34-interview-with-ray-s-cline-1982", rest: []},
      {name: "Le Van Phuc", first: "vietnam-29f4cd-interview-with-le-van-phuc-1981", rest: []},
      {name: "Horace W. Busby", first: "vietnam-fa3035-interview-with-horace-w-busby-1981", rest: []},
      {name: "Hoang Duc Nha", first: "vietnam-2dd99e-interview-with-hoang-duc-nha-2-1981", rest: []},
      {name: "Francois Ponchaud", first: "vietnam-2be511-interview-with-francois-ponchaud-1982", rest: []},
      {name: "Frederick Nolting", first: "vietnam-454634-interview-with-frederick-nolting-1981", rest: []},
      {name: "Mrs Nguyen Congminh", first: "vietnam-43b0a0-interview-with-mrs-nguyen-cong-minh", rest: []},
      {name: "Lam Son Nao", first: "vietnam-28d91f-interview-with-lam-son-nao-1981", rest: []},
      {name: "Nguyen Thi Tuyet", first: "vietnam-770459-interview-with-nguyen-thi-tuyet-1981", rest: []},
      {name: "Hoang Quoc Viet", first: "vietnam-b91a7c-interview-with-hoang-quoc-viet-1981", rest: []},
      {name: "Le Van Tri", first: "vietnam-1094ae-interview-with-le-van-tri-1981", rest: []},
      {name: "John James Flynt Jr." , first: "vietnam-723591-interview-with-john-james-flynt-jr-1982", rest: []},
      {name: "Herbert Bluechel", first: "vietnam-e01ec4-interview-with-herbert-bluechel-1981", rest: []},
      {name: "Nguyen Cong Danh", first: "vietnam-d87012-interview-with-nguyen-cong-danh-1981", rest: []},
      {name: "Philip Geoffrey Malins", first: "vietnam-164308-interview-with-philip-geoffrey-malins-1982", rest: []},
      {name: "Sisouk Na Champassak", first: "vietnam-557711-interview-with-sisouk-na-champassak-1982", rest: []},
      {name: "Le Van Ba", first: "vietnam-0eb6d9-interview-with-le-van-ba-1981", rest: []},
      {name: "Nguyen Khac Ham", first: "vietnam-b2e4a5-interview-with-nguyen-khac-ham-1981", rest: []},
      {name: "Sok Sarren", first: "vietnam-467d30-interview-with-sok-sarren-1982", rest: []},
      {name: "Tran Vi Truong", first: "vietnam-943c96-interview-with-tran-vi-truong-1981", rest: []},
      {name: "Phung The Tai", first: "vietnam-21f0b4-interview-with-phung-the-tai-1981", rest: []},
      {name: "Tomlyons", first: "vietnam-a957b5-interview-with-tom-lyons", rest: []},
      {name: "Nguyen Co Thach", first: "vietnam-7699e6-interview-with-nguyen-co-thach-1981", rest: []},
      {name: "Nguyen Tat Dat", first: "vietnam-e1ea29-interview-with-nguyen-tat-dat-1981", rest: []},
      {name: "Ngo Thi Hien", first: "vietnam-60ee60-interview-with-ngo-thi-hien-1981", rest: []},
      {name: "Pengthuon", first: "vietnam-7b0ea1-interview-with-peng-thuon", rest: []},
      {name: "Phung Thi Tiem", first: "vietnam-b427ab-interview-with-phung-thi-tiem-1981", rest: []},
      {name: "Le Cong Chinh (part 2)", first: "vietnam-d145a9-interview-with-le-cong-chinh-2-1981", rest: []},
      {name: "Phuong Nam", first: "vietnam-6048eb-interview-with-phuong-nam-1981", rest: []},
      {name: "William H. William Healy Sullivan", first: "vietnam-fe59dc-interview-with-william-h-william-healy-sullivan-1981", rest: []},
      {name: "James M. Fallows", first: "vietnam-209caf-interview-with-james-m-fallows-1982", rest: []},
      {name: "Tran Ding Thong", first: "vietnam-9839f7-interview-with-tran-ding-thong-1981", rest: []},
      {name: "Tho Hang", first: "vietnam-a68b58-interview-with-tho-hang-1-1981",
        rest: ["vietnam-1eb64e-interview-with-tho-hang-2-1981"]
      },
      {name: "Frank Snepp", first: "vietnam-501236-interview-with-frank-snepp-1981", rest: []},
      {name: "Pham Thanh Gion", first: "vietnam-539a4c-interview-with-pham-thanh-gion-1981", rest: []},
      {name: "Tran Do", first: "vietnam-8915b6-interview-with-tran-do-1981", rest: []},
      {name: "Nguyen Thi Ngo", first: "vietnam-975432-interview-with-nguyen-thi-ngo-1981", rest: []},
      {name: "Nguyen Thi Cao", first: "vietnam-9d953e-interview-with-nguyen-thi-cao-1981", rest: []},
      {name: "Tran Vandon", first: "vietnam-b01a66-interview-with-tran-van-don", rest: []},
      {name: "Pham Van Thu", first: "vietnam-87380c-interview-with-pham-van-thu-1981", rest: []},
      {name: "Roger Hilsman", first: "vietnam-c3d5d3-interview-with-roger-hilsman-1981", rest: []},
      {name: "Nguyen Van", first: "vietnam-4c8279-interview-with-nguyen-van-1981", rest: []},
      {name: "Nguyen Thi Trong", first: "vietnam-22e706-interview-with-nguyen-thi-trong-1981", rest: []},
      {name: "Woman In Street", first: "vietnam-5c1f3c-interview-with-woman-in-street-1981", rest: []},
      {name: "Cao Xuan Nghia", first: "vietnam-762429-interview-with-cao-xuan-nghia-1981", rest: []},
      {name: "Thich Minh Chau", first: "vietnam-101322-interview-with-thich-minh-chau-1981", rest: []},
      {name: "Nham Cam", first: "vietnam-0dfb8e-interview-with-nham-cam-1981", rest: []},
      {name: "Edward J. Banks", first: "vietnam-12991e-interview-with-edward-j-banks-1982", rest: []},
      {name: "Tran Van Ngo", first: "vietnam-094e1e-interview-with-tran-van-ngo-1981", rest: []},
      {name: "Y True Nie", first: "vietnam-ba3f2d-interview-with-y-true-nie-1981", rest: []},
      {name: "Nguyen Thi Duc", first: "vietnam-d51556-interview-with-nguyen-thi-duc-1981", rest: []},
      {name: "Tran Thi Giai", first: "vietnam-76fb17-interview-with-tran-thi-giai-1981", rest: []},
      {name: "Dean Rusk", first: "vietnam-58a64d-interview-with-dean-rusk-2-1981", rest: []},
      {name: "Nguyen Thanh Xuan", first: "vietnam-75fa47-interview-with-nguyen-thanh-xuan-1981", rest: []},
      {name: "Robinson Risner", first: "vietnam-0b40bf-interview-with-robinson-risner-1981", rest: []},
      {name: "Ray Snyder", first: "vietnam-839fcc-interview-with-ray-snyder-1981", rest: []},
      {name: "Nguyen Thi Thiep", first: "vietnam-d3ee9a-interview-with-nguyen-thi-thiep-1981", rest: []},
      {name: "Duong Thi My Trung", first: "vietnam-643281-interview-with-duong-thi-my-trung-1981", rest: []},
      {name: "Tran Ngocluong", first: "vietnam-12c023-interview-with-tran-ngoc-luong", rest: []},
      {name: "Carleton Swift", first: "vietnam-9dc948-interview-with-carleton-swift", rest: []},
      {name: "Thich Tri Thu", first: "vietnam-e52827-interview-with-thich-tri-thu-1981", rest: []},
      {name: "Phan Phung Tien", first: "vietnam-856d86-interview-with-phan-phung-tien-1981", rest: []},
      {name: "Ralph C. Thomas Iii", first: "vietnam-c344d8-interview-with-ralph-c-thomas-iii-1981", rest: []},
      {name: "Thruong Yem", first: "vietnam-1cfa79-interview-with-thruong-yem-1981", rest: []},
      {name: "Everett Alvarez", first: "vietnam-fd03ef-interview-with-everett-alvarez-1981", rest: []},
      {name: "Y Luong Bya", first: "vietnam-45718a-interview-with-y-luong-bya-1981", rest: []},
      {name: "Charles Sabatier", first: "vietnam-c7c7c9-interview-with-charles-sabatier-1982-part-1-of-2",
        rest: [
          "vietnam-eebf58-interview-with-charles-sabatier-1982-part-2-of-2"
        ]
      },
      {name: "Thich Tu Hanh", first: "vietnam-82584c-interview-with-thich-tu-hanh-1981", rest: []},
      {name: "Vo Van Nhung", first: "vietnam-b1ba00-interview-with-vo-van-nhung-1981", rest: []},
      {name: "Ural Alexis Johnson", first: "vietnam-8372ad-interview-with-u-alexis-ural-alexis-johnson-1982", rest: []},
      {name: "Tran Ngoc Lieng", first: "vietnam-f113a8-interview-with-tran-ngoc-lieng-1981", rest: []},
      {name: "Y Bloc", first: "vietnam-3ff8fe-interview-with-y-bloc-1981", rest: []},
      {name: "Le Dinh Hy", first: "vietnam-efa891-interview-with-le-dinh-hy-1981", rest: []},
      {name: "Tran Nhat Bang", first: "vietnam-e1e580-interview-with-tran-nhat-bang-1981", rest: []},
      {name: "James Claude Thomson", first: "vietnam-cda8e9-interview-with-james-claude-thomson-1981", rest: []},
      {name: "Thuong Thi Mai", first: "vietnam-ad8dda-interview-with-thuong-thi-mai-1981", rest: []},
      {name: "Frank M. White", first: "vietnam-213564-interview-with-frank-m-white-1981", rest: []},
      {name: "Nguyen Huu", first: "vietnam-64bf4f-interview-with-nguyen-huu-1981", rest: []},
      {name: "Pham Duy", first: "vietnam-b19ea1-interview-with-pham-duy-1982", rest: []},
      {name: "Bui Tin", first: "vietnam-f8ca90-interview-with-bui-tin-1-1981",
        rest: ["vietnam-f729b0-interview-with-bui-tin-2-1981"]
      },
      {name: "Walt Whitman Rostow", first: "vietnam-c8f4ed-interview-with-w-w-walt-whitman-rostow-1981", rest: []},
      {name: "Madame Duong Van Khang", first: "vietnam-42008e-interview-with-madame-duong-van-khang-1981", rest: []},
      {name: "William Averell Harriman", first: "vietnam-436bdd-interview-with-w-averell-william-averell-harriman-1979-part-1-of-4",
        rest: [
          "vietnam-e996c7-interview-with-w-averell-william-averell-harriman-1979-part-2-of-4",
          "vietnam-dff8f9-interview-with-w-averell-william-averell-harriman-1979-part-3-of-4",
          "vietnam-66ca94-interview-with-w-averell-william-averell-harriman-1979-part-4-of-4"
        ]
      },
      {name: "Do Thi Bay", first: "vietnam-cac6a5-interview-with-do-thi-bay-1981", rest: []},
      {name: "J. Lawton Collins", first: "vietnam-264d70-interview-with-j-lawton-collins-1981", rest: []},
      {name: "Ngo Dinhluyen", first: "vietnam-0c7985-interview-with-ngo-dinh-luyen", rest: []},
      {name: "Ton That Thien", first: "vietnam-18db13-interview-with-ton-that-thien-1981", rest: []},
      {name: "R. W. Komer", first: "vietnam-0194f2-interview-with-r-w-komer-1982", rest: []},
      {name: "Henry Kissinger", first: "vietnam-ce422e-interview-with-henry-kissinger-1982", rest: []},
      {name: "William E. Le Gro", first: "vietnam-e7fe8a-interview-with-william-e-le-gro-1981", rest: []},
      {name: "Gerald R. Ford", first: "vietnam-de3a13-interview-with-gerald-r-ford-1982", rest: []},
      {name: "Paul C. Warnke", first: "vietnam-050761-interview-with-paul-c-warnke-1982", rest: []},
      {name: "Earl Young", first: "vietnam-03e0bb-interview-with-earl-young-1981", rest: []},
      {name: "Dean Rusk", first: "vietnam-6f0280-interview-with-dean-rusk-1-1982", rest: []},
      {name: "Eldridge Durbrow", first: "vietnam-078fff-interview-with-eldridge-durbrow-1979-part-1-of-2",
        rest: [
          "vietnam-2eb162-interview-with-eldridge-durbrow-1979-part-2-of-2"
        ]
      },
      {name: "Myron Harrington", first: "vietnam-de0a9d-interview-with-myron-harrington-1981", rest: []},
      {name: "Henry Cabot Lodge", first: "vietnam-b93dd4-interview-with-henry-cabot-lodge-1979-part-1-of-5",
        rest: [
          "vietnam-dbabfd-interview-with-henry-cabot-lodge-1979-part-2-of-5",
          "vietnam-228c4a-interview-with-henry-cabot-lodge-1979-part-3-of-5",
          "vietnam-0122cd-interview-with-henry-cabot-lodge-1979-part-4-of-5",
          "vietnam-83f288-interview-with-henry-cabot-lodge-1979-part-5-of-5"
        ]
      },
      {name: "Carl F. Bernard", first: "vietnam-16d140-interview-with-carl-f-bernard-1981", rest: []},
      {name: "Edward Geary Lansdale", first: "vietnam-f1001a-interview-with-edward-geary-lansdale-1979-part-1-of-5",
        rest: [
          "vietnam-8fe831-interview-with-edward-geary-lansdale-1979-part-2-of-5",
          "vietnam-4ba46a-interview-with-edward-geary-lansdale-1979-part-3-of-5",
          "vietnam-2f8f83-interview-with-edward-geary-lansdale-1979-part-4-of-5",
          "vietnam-a9fa62-interview-with-edward-geary-lansdale-1979-part-5-of-5"
        ]
      },
      {name: "Tran Thi Tuyet", first: "vietnam-88b680-interview-with-tran-thi-tuyet-1981", rest: []},
      {name: "Nguyen Ky", first: "vietnam-7c2879-interview-with-nguyen-ky-1981", rest: []},
      {name: "Maxwell Davenport Taylor", first: "vietnam-f7ff45-interview-with-maxwell-d-maxwell-davenport-taylor-1979-part-1-of-4",
        rest: [
          "vietnam-b063c6-interview-with-maxwell-d-maxwell-davenport-taylor-1979-part-2-of-4",
          "vietnam-24d1db-interview-with-maxwell-d-maxwell-davenport-taylor-1979-part-3-of-4",
          "vietnam-188cda-interview-with-maxwell-d-maxwell-davenport-taylor-1979-part-4-of-4"
        ]
      },
      {name: "Nguyen Chi Thanh", first: "vietnam-f74415-interview-with-nguyen-chi-thanh-1981", rest: []},
      {name: "Nguyen Thinhi", first: "vietnam-5456ea-interview-with-nguyen-thi-nhi", rest: []},
      {name: "David Harris", first: "vietnam-08d0a8-interview-with-david-harris-1982", rest: []},
      {name: "David Halberstam", first: "vietnam-86e38f-interview-with-david-halberstam-1979-part-1-of-5",
        rest: [
          "vietnam-cbedc8-interview-with-david-halberstam-1979-part-2-of-5",
          "vietnam-ae77bf-interview-with-david-halberstam-1979-part-3-of-5",
          "vietnam-f13fc4-interview-with-david-halberstam-1979-part-4-of-5",
          "vietnam-2602a8-interview-with-david-halberstam-1979-part-5-of-5"
        ]
      },
      {name: "Lucien Bodard", first: "vietnam-4867ab-interview-with-lucien-bodard-1981", rest: []},
      {name: "Ngo Thi Tan", first: "vietnam-b18d7f-interview-with-ngo-thi-tan-1981", rest: []},
      {name: "Robert Montague (audio only)", first: "vietnam-e5b3d3-interview-with-robert-montague-1982", rest: []},
      {name: "Phuong Doan (audio only)", first: "vietnam-bab15f-interview-with-phuong-doan-1983", rest: []},
      {name: "Gillespie V. Montgomery (audio only)", first: "vietnam-068767-interview-with-g-v-gillespie-v-montgomery-1983", rest: []},
      {name: "Arthur Egendorf (audio only)", first: "vietnam-02f66a-interview-with-arthur-egendorf-1983", rest: []},
      {name: "John Wheeler (audio only)", first: "vietnam-c9d95f-interview-with-john-wheeler-1981", rest: []},
      {name: "David Christian (audio only)", first: "vietnam-6891de-interview-with-david-christian-1983", rest: []},
      {name: "Harold Robert Isaacs (audio only)", first: "vietnam-83910d-interview-with-harold-robert-isaacs-1981", rest: []},
      {name: "Richard C. Holbrooke (part 1 - audio only)", first: "vietnam-6c7004-interview-with-richard-c-holbrooke-1-1983", rest: []},
      {name: "David R. Hawk (audio only)", first: "vietnam-5dc58b-interview-with-david-r-hawk-1983", rest: []},
      {name: "Maureen Hatch (audio only)", first: "vietnam-5c031c-interview-with-maureen-hatch-1983", rest: []},
      {name: "Dith Pran (audio only)", first: "vietnam-7ab1a2-interview-with-dith-pran-1983", rest: []},
      {name: "Greg Kane (audio only)", first: "vietnam-f3de53-interview-with-greg-kane-1983", rest: []},
      {name: "Muoi Van Nguyen (audio only)", first: "vietnam-af8d79-interview-with-muoi-van-nguyen-1983", rest: []},
      {name: "Edward C. Meyer", first: "vietnam-d325e6-interview-with-edward-c-meyer", rest: []},
      {name: "Nguyen Minh", first: "vietnam-fa23c2-interview-with-nguyen-minh", rest: []},
      {name: "Zbigniew Brzezinski (audio only)", first: "vietnam-fc1f9b-interview-with-zbigniew-brzezinski-1983", rest: []},
      {name: "Stephen J. Solarz (audio only)", first: "vietnam-4f99ee-interview-with-stephen-j-solarz-1983", rest: []},
      {name: "Le Cong Chinh (part 1 - audio only)", first: "vietnam-8903eb-interview-with-le-cong-chinh-1-1981", rest: []},
      {name: "Bob Muller (audio only)", first: "vietnam-3eef1c-interview-with-bob-muller-1983", rest: []},
      {name: "Mary Truong", first: "vietnam-ce6b38-interview-with-mary-truong", rest: []},
      {name: "Nguyen Tinh", first: "vietnam-dd6e8f-interview-with-nguyen-tinh", rest: []},
      {name: "Long Duong (audio only)", first: "vietnam-228ae7-interview-with-long-duong-1983", rest: []},
      {name: "Mark Leighton (audio only)", first: "vietnam-d90da9-interview-with-mark-leighton-1983", rest: []},
      {name: "Indor Jag Mohan (audio only)", first: "vietnam-b8d73b-interview-with-indor-jag-mohan-1981", rest: []},
      {name: "Robinson Risner (audio only)", first: "471a9e-interview-with-robinson-risner-1981", rest: []},
      {name: "Ted Danielsen (transcript only)", first: "vietnam-89f5a4-interview-with-ted-danielsen-1981", rest: []},
      {name: "Daniel Ellsberg (transcript only)", first: "vietnam-354cac-interview-with-daniel-ellsberg", rest: []},
      {name: "Don Luce (transcript only)", first: "vietnam-edfd42-interview-with-don-luce", rest: []},
      {name: "Orrin DeForest (transcript only)", first: "vietnam-b98ddf-interview-with-orrin-deforest", rest: []},
      {name: "Douglas Hostetter (transcript only)", first: "vietnam-556c2f-interview-with-douglas-hostetter", rest: []},
      {name: "John T. McAllister (transcript only)", first: "vietnam-ec6417-interview-with-john-t-mcallister", rest: []},
      {name: "Astor Rogers (transcript only)", first: "vietnam-288ff4-interview-with-astor-rogers", rest: []},
      {name: "David Ross (transcript only)", first: "vietnam-966e54-interview-with-david-ross", rest: []},
      {name: "James N. Rowe (transcript only)", first: "vietnam-37285a-interview-with-james-n-rowe", rest: []},
      {name: "Tran Ngoc Chau (transcript only)", first: "vietnam-fee2f8-interview-with-tran-ngoc-chau", rest: []},
      {name: "Mark Smith (transcript only)", first: "vietnam-7ebc56-interview-with-mark-smith-1-1982",
        rest: ["vietnam-03128b-interview-with-mark-smith-2"]
      },
      {name: "William D. Ehrhart (transcript only)", first: "vietnam-bca896-interview-with-william-d-ehrhart-1-1982",
        rest: ["vietnam-e2cd2c-interview-with-william-d-ehrhart-2"]
      },
    ].sort_by! {|interview| interview[:name] }

    render file: 'override/catalog/vietnam-the-vietnam-collection'
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
    # TODO: tabs UI is now being cached, so hitting this on every request is wasteful.
    Blacklight.solr.select(params: {q: q})['response']['docs'].map{|d|d['id']}
  end

end 
