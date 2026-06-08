-- ============================================================
-- LeagueIQ — Seed: La Liga Questions (210)
-- 30 per category × 7 categories
-- ============================================================

do $$
declare
  v_league  uuid := '22222222-2222-2222-2222-222222222222';
  v_ch      uuid; -- club_history
  v_fp      uuid; -- famous_players
  v_ec      uuid; -- el_clasico
  v_rs      uuid; -- records_stats
  v_mg      uuid; -- managers
  v_tr      uuid; -- transfers
  v_sc      uuid; -- stadium_culture
begin
  select id into v_ch from public.categories where league_id = v_league and slug = 'club_history';
  select id into v_fp from public.categories where league_id = v_league and slug = 'famous_players';
  select id into v_ec from public.categories where league_id = v_league and slug = 'el_clasico';
  select id into v_rs from public.categories where league_id = v_league and slug = 'records_stats';
  select id into v_mg from public.categories where league_id = v_league and slug = 'managers';
  select id into v_tr from public.categories where league_id = v_league and slug = 'transfers';
  select id into v_sc from public.categories where league_id = v_league and slug = 'stadium_culture';

  -- ============================================================
  -- CLUB HISTORY (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_ch, 'In what year was Real Madrid founded?',
   '["1898","1900","1902","1905"]', 2, 'easy',
   'Real Madrid was founded on 6 March 1902 as Madrid Football Club. King Alfonso XIII granted the club the title "Real" (Royal) in 1920.'),

  (v_league, v_ch, 'FC Barcelona was founded in which year?',
   '["1895","1899","1902","1906"]', 1, 'easy',
   'FC Barcelona was founded on 29 November 1899 by Joan Gamper, a Swiss businessman, along with 11 other members. Their motto is "Més que un club" — More than a club.'),

  (v_league, v_ch, 'Real Madrid has won the most La Liga titles. How many have they won as of the 2023–24 season?',
   '["28","32","36","40"]', 2, 'medium',
   'Real Madrid have won 36 La Liga titles, making them the most successful club in Spanish football history.'),

  (v_league, v_ch, 'FC Barcelona has won La Liga how many times as of 2023–24?',
   '["20","24","27","30"]', 2, 'medium',
   'FC Barcelona have won La Liga 27 times — second only to Real Madrid. Their last title before 2022–23 came in 2018–19.'),

  (v_league, v_ch, 'Which Spanish club is nicknamed "Los Colchoneros" (The Mattress Makers)?',
   '["Sevilla FC","Atlético de Madrid","Real Betis","Valencia CF"]', 1, 'easy',
   'Atlético de Madrid are nicknamed "Los Colchoneros" (The Mattress Makers) because the area near the Manzanares river where they traditionally played was associated with mattress-making workers.'),

  (v_league, v_ch, 'Athletic Club of Bilbao is unique for which policy?',
   '["Only fielding players born on Tuesdays","Only signing players from the Basque Country","Playing every match in white","Never using substitutes in the 1970s"]', 1, 'easy',
   'Athletic Club maintain a strict cantera policy of only signing players who were born, raised, or trained in the Basque Country. Despite this restriction, they have never been relegated from La Liga.'),

  (v_league, v_ch, 'Valencia CF were founded in which year?',
   '["1899","1909","1919","1929"]', 2, 'medium',
   'Valencia CF were founded on 18 March 1919. The club is nicknamed "Los Che" and "Los Murciélagos" (The Bats), with a bat appearing on their crest — a reference to James I of Aragon''s coat of arms.'),

  (v_league, v_ch, 'Which club is the only one to have remained in La Liga since its very first season in 1929?',
   '["Barcelona","Real Madrid","Athletic Club","Atlético de Madrid"]', 2, 'medium',
   'Athletic Club de Bilbao have been in every La Liga season since the inaugural 1929 campaign without ever being relegated — a remarkable achievement maintained through their cantera policy.'),

  (v_league, v_ch, 'Real Madrid won how many consecutive European Cups/Champions League titles from 1956 to 1960?',
   '["3","4","5","6"]', 2, 'easy',
   'Real Madrid won the European Cup five consecutive times from 1956 to 1960, a record that still stands. Their squad featured legends like Alfredo Di Stéfano and Ferenc Puskás.'),

  (v_league, v_ch, 'What is the name of the regional derby between Barcelona and Espanyol?',
   '["El Clásico","El Derbi barceloní","El Gran Derby","La Batalla de Cataluña"]', 1, 'medium',
   'The derby between FC Barcelona and RCD Espanyol is called "El Derbi barceloní" (The Barcelona Derby). It is an intense fixture fuelled by political and cultural differences.'),

  (v_league, v_ch, 'Sevilla FC has won the most UEFA Europa League titles. How many?',
   '["4","5","6","7"]', 2, 'medium',
   'Sevilla FC have won the UEFA Europa League (including its predecessor the UEFA Cup) a record seven times (2006, 2007, 2014, 2015, 2016, 2020, 2023).'),

  (v_league, v_ch, 'Which La Liga club was founded as a way for Swiss and English workers to play football in Madrid?',
   '["Rayo Vallecano","Atlético de Madrid","Real Madrid","Getafe CF"]', 2, 'hard',
   'Real Madrid was co-founded by Julián Palacios, who met with other football enthusiasts including Cambridge University students. The club''s English influence is reflected in the use of the name "Football Club" in early documentation.'),

  (v_league, v_ch, 'Atlético de Madrid have won La Liga how many times?',
   '["7","9","11","13"]', 2, 'medium',
   'Atlético de Madrid have won La Liga 11 times, with their most recent titles coming under Diego Simeone in 2013–14 and 2020–21.'),

  (v_league, v_ch, 'Real Betis was founded in which city?',
   '["Madrid","Valencia","Seville","Bilbao"]', 2, 'easy',
   'Real Betis Balompié is based in Seville, making them one of two La Liga clubs from the city alongside arch-rivals Sevilla FC. Their derby is known as "El Gran Derbi."'),

  (v_league, v_ch, 'Which La Liga club is known as "Los Blancos"?',
   '["Atlético de Madrid","FC Barcelona","Real Madrid","Valencia CF"]', 2, 'easy',
   '"Los Blancos" (The Whites) is Real Madrid''s most common nickname, referring to their all-white home kit adopted in the early 20th century.'),

  (v_league, v_ch, 'La Liga was first played in which year?',
   '["1920","1925","1929","1935"]', 2, 'medium',
   'The first La Liga season was played in 1929, with Barcelona winning the inaugural championship. The league has been played continuously since, except during the Spanish Civil War (1936–39).'),

  (v_league, v_ch, 'Which club shares the Santiago Bernabéu stadium as their home ground along with Real Madrid?',
   '["No other club — it''s solely Real Madrid''s","Atlético de Madrid","Rayo Vallecano","Real Madrid Castilla"]', 0, 'hard',
   'The Santiago Bernabéu is solely the home of Real Madrid. Real Madrid Castilla (the reserve team) plays at the Estadio Alfredo Di Stéfano at the training complex.'),

  (v_league, v_ch, 'Deportivo de La Coruña won their only La Liga title in which season?',
   '["1998–99","1999–2000","2000–01","2001–02"]', 1, 'hard',
   'Deportivo de La Coruña won their only La Liga title in the 1999–2000 season under Javier Irureta, pipping Barcelona and Valencia in one of the most surprising title wins in Spanish football.'),

  (v_league, v_ch, 'Which La Liga club was saved from financial collapse and reformed as a fan-owned club in 2011?',
   '["Málaga CF","Real Oviedo","Rayo Vallecano","Hércules CF"]', 1, 'hard',
   'Real Oviedo faced extinction in 2012 but was saved by a crowdfunding campaign including contributions from fans worldwide and a donation from Sunderland fan and then club owner Ellis Short. They were eventually reformed.'),

  (v_league, v_ch, 'Real Madrid''s "Galácticos" era refers to which period?',
   '["Late 1980s","Late 1990s","Early 2000s","Early 2010s"]', 2, 'medium',
   'The "Galácticos" era (early 2000s) saw Real Madrid president Florentino Pérez sign a global superstar every summer: Figo, Zidane, Ronaldo, Beckham, Owen. Despite the star power, they had limited league success.'),

  (v_league, v_ch, 'Barcelona''s "Dream Team" of the early 1990s won four consecutive La Liga titles under which manager?',
   '["Louis van Gaal","Johan Cruyff","Pep Guardiola","Frank Rijkaard"]', 1, 'medium',
   'Johan Cruyff''s Barcelona "Dream Team" (1988–1996) won four consecutive La Liga titles from 1990–91 to 1993–94, playing beautiful attacking football that laid the foundation for the tiki-taka era.'),

  (v_league, v_ch, 'What nationality was Real Madrid co-founder and first president Carlos Padros?',
   '["Spanish","French","British","Swiss"]', 0, 'hard',
   'Carlos Padrós was Spanish (of Catalan origin). He served as the club''s first president and was instrumental in organising early Spanish football competitions.'),

  (v_league, v_ch, 'Real Betis ended a long trophy drought by winning the Copa del Rey in 2022. Who did they beat in the final?',
   '["Sevilla","Real Sociedad","Athletic Bilbao","Valencia"]', 1, 'hard',
   'Real Betis beat Real Sociedad on penalties in the 2022 Copa del Rey Final at Estadio de La Cartuja in Seville — their first major trophy since 2005 and only the second Copa del Rey in the club''s history.'),

  (v_league, v_ch, 'Which La Liga club has the famous "Roar of the Lions" trophy room?',
   '["Athletic Club","Real Madrid","Atlético de Madrid","Sevilla"]', 0, 'hard',
   'Athletic Club de Bilbao have a storied trophy room and are deeply connected to Basque culture. Their eight La Liga titles and 23 Copa del Rey wins make them one of Spain''s most successful clubs.'),

  (v_league, v_ch, 'Girona FC reached the Champions League for the first time in their history after finishing in which position in La Liga 2023–24?',
   '["Second","Third","Fourth","Fifth"]', 1, 'medium',
   'Girona FC had a remarkable 2023–24 La Liga season, finishing third (and at one point leading the table) to qualify for the Champions League for the first time in the club''s history.'),

  (v_league, v_ch, 'Which La Liga club was previously known as "Foot-Ball Club Barcelona" and adopted the current name in which year?',
   '["1900","1905","1910","1919"]', 0, 'hard',
   'FC Barcelona used various names in their early years. The Catalan name "Futbol Club Barcelona" has been used throughout their existence but the official statutes have evolved since their 1899 founding.'),

  (v_league, v_ch, 'Real Madrid won La Liga in 2021–22 with how many points?',
   '["81","83","86","88"]', 2, 'medium',
   'Real Madrid won the 2021–22 La Liga with 86 points, 13 points clear of second-placed Barcelona. Carlo Ancelotti guided them to the league and Champions League double.'),

  (v_league, v_ch, 'Which city is home to two La Liga clubs in the same stadium?',
   '["Madrid","Seville","Valencia","Málaga"]', 0, 'hard',
   'No La Liga city currently shares a stadium between two clubs at the top level, though Atlético and Real both called Madrid home and shared the Estadio Metropolitano area historically. Seville has two clubs (Sevilla and Betis) in different stadiums.'),

  (v_league, v_ch, 'Osasuna is a club from which Spanish city?',
   '["Pamplona","Zaragoza","San Sebastián","Burgos"]', 0, 'medium',
   'Club Atlético Osasuna is based in Pamplona, the capital of the Navarre region in northern Spain. They are known for their passionate supporters and their characteristic red and blue kit.'),

  (v_league, v_ch, 'Which La Liga club won back-to-back Copa del Rey titles in 2022 and 2023?',
   '["Real Madrid","FC Barcelona","Real Betis","Athletic Club"]', 1, 'medium',
   'FC Barcelona won the Copa del Rey in 2021, then Real Betis in 2022, then FC Barcelona again in 2023 — Barça''s back-to-back wins in 2022–23 under Xavi coming with a dominant domestic season.'),

  (v_league, v_ch, 'What is the name of La Liga''s official trophy?',
   '["The Copa","The Zamora","La Liga Trophy","The Copa del Generalísimo"]', 2, 'hard',
   'The La Liga Trophy is officially awarded to the champion each season. It has no separate historical name like the Premier League trophy — it is simply presented as the La Liga championship trophy.');

  -- ============================================================
  -- FAMOUS PLAYERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_fp, 'Who is the all-time top scorer in La Liga history?',
   '["Raúl","Cristiano Ronaldo","Hugo Sánchez","Lionel Messi"]', 3, 'easy',
   'Lionel Messi scored 474 La Liga goals for FC Barcelona between 2004 and 2021, making him the competition''s all-time leading scorer — far ahead of Cristiano Ronaldo''s 311.'),

  (v_league, v_fp, 'Cristiano Ronaldo won the La Liga Pichichi (top scorer) award how many times?',
   '["1","2","3","4"]', 1, 'medium',
   'Cristiano Ronaldo won the La Liga Pichichi top scorer award twice, in 2010–11 (40 goals) and 2014–15 (48 goals). Messi won it eight times during Ronaldo''s nine seasons at Real Madrid.'),

  (v_league, v_fp, 'Which Argentine legend joined Real Madrid from River Plate in 1953 and became their greatest ever player?',
   '["Diego Maradona","Alfredo Di Stéfano","Jorge Valdano","Gabriel Batistuta"]', 1, 'easy',
   'Alfredo Di Stéfano is widely regarded as the greatest footballer of his era and the key player in Real Madrid''s five consecutive European Cup wins (1956–60). He scored in all five finals.'),

  (v_league, v_fp, 'Which Spanish striker won the Pichichi award six times in the 1950s and is considered one of Spain''s greatest ever players?',
   '["Fernando Hierro","Emilio Butragueño","Telmo Zarra","Fernando Torres"]', 2, 'hard',
   'Telmo Zarra is one of La Liga''s greatest ever goalscorers, holding the record for most Pichichi awards before Messi. He scored 251 goals in La Liga for Athletic Club.'),

  (v_league, v_fp, 'Ronaldinho won the Ballon d''Or in 2005. Which club was he at?',
   '["Paris Saint-Germain","AC Milan","FC Barcelona","Real Madrid"]', 2, 'easy',
   'Ronaldinho was at FC Barcelona when he won the 2005 Ballon d''Or, lighting up La Liga with his joyful dribbling, tricks, and goals. He helped Barcelona win La Liga in 2004–05 and 2005–06.'),

  (v_league, v_fp, 'Raúl is Real Madrid''s historic captain and legend. How many La Liga seasons did he spend at the club?',
   '["12","14","16","18"]', 2, 'hard',
   'Raúl spent 16 seasons at Real Madrid (1994–2010) and became the club''s all-time top scorer before Cristiano Ronaldo. He won La Liga 6 times and the Champions League 3 times.'),

  (v_league, v_fp, 'Fernando Torres made his La Liga debut aged just 17 for which club?',
   '["Atlético de Madrid","Real Madrid","Sevilla","Deportivo de La Coruña"]', 0, 'medium',
   'Fernando Torres made his professional debut for Atlético de Madrid in May 2001, aged 17. He became club captain at 19 and scored 82 goals for Atlético before his controversial move to Liverpool.'),

  (v_league, v_fp, 'Which midfielder was the creative heart of Barcelona''s "tiki-taka" era under Pep Guardiola?',
   '["Sergio Busquets","Xavi Hernández","Andrés Iniesta","All three equally"]', 3, 'medium',
   'Xavi Hernández, Andrés Iniesta, and Sergio Busquets formed the backbone of Barcelona''s tiki-taka midfield. All three also formed Spain''s World Cup and Euro-winning midfield (2008–2012).'),

  (v_league, v_fp, 'Which Brazilian striker signed for Barcelona in 2000 and became known as "Barça''s Brazilian"?',
   '["Romário","Ronaldo","Rivaldo","Ronaldinho"]', 2, 'medium',
   'Rivaldo joined Barcelona from Deportivo de La Coruña in 1997 and won two La Liga titles and the 1999 Ballon d''Or. He scored 130 goals for the club across 5 seasons.'),

  (v_league, v_fp, 'Which Real Madrid goalkeeper won the Zamora Trophy (La Liga''s best goalkeeper) a record five times?',
   '["Iker Casillas","Jerzy Dudek","Santiago Cañizares","Andoni Zubizarreta"]', 0, 'medium',
   'Iker Casillas won the Zamora Trophy (for the goalkeeper with the best goals-against ratio) five times during his Real Madrid career and is widely considered one of Spain''s greatest ever goalkeepers.'),

  (v_league, v_fp, 'Which player holds the record for most La Liga assists?',
   '["Cesc Fàbregas","Xavi Hernández","Andrés Iniesta","Lionel Messi"]', 3, 'hard',
   'Lionel Messi holds the record for most La Liga assists with 192 assists provided during his time at FC Barcelona (2004–2021), adding to his record 474 goals.'),

  (v_league, v_fp, 'David Beckham spent two seasons at Real Madrid (2003–05) before joining which club?',
   '["AC Milan","LA Galaxy","Manchester United","Chelsea"]', 1, 'medium',
   'David Beckham joined LA Galaxy in MLS in January 2007, leaving Real Madrid where he had been a "Galáctico." He later had loan spells at AC Milan and Paris Saint-Germain.'),

  (v_league, v_fp, 'Which Brazilian winger dribbled past four England defenders in the 2002 World Cup quarter-final, then went on to become La Liga''s biggest star?',
   '["Ronaldo","Ronaldinho","Rivaldo","Roberto Carlos"]', 1, 'hard',
   'Ronaldinho''s mazy dribble past four England defenders in the 2002 World Cup quarter-final made him world famous. He joined Barcelona from PSG in 2003 and won the Ballon d''Or in 2005, lighting up La Liga with his joyful skill.'),

  (v_league, v_fp, 'Which Spanish forward became a legend at Atlético de Madrid, known as "El Niño del Pueblo"?',
   '["Fernando Torres","Fernando Morientes","Radamel Falcao","Diego Forlán"]', 0, 'medium',
   'Fernando Torres was nicknamed "El Niño" (The Kid) at Atlético de Madrid, where he came through the youth system. His emotional connections to the club remained even after leaving for Liverpool.'),

  (v_league, v_fp, 'Who has won the Ballon d''Or a record eight times, more than any other player in history?',
   '["Cristiano Ronaldo","Lionel Messi","Johan Cruyff","Michel Platini"]', 1, 'easy',
   'Lionel Messi has won the Ballon d''Or a record eight times (2009, 2010, 2011, 2012, 2015, 2019, 2021, 2023) — all during his time at FC Barcelona and later PSG. Cristiano Ronaldo has won it five times.'),

  (v_league, v_fp, 'Which Mexican striker won the Pichichi award five times in the 1980s and is regarded as one of La Liga''s greatest foreign players?',
   '["Hugo Sánchez","Luis García","Emilio Butragueño","Míchel"]', 0, 'medium',
   'Hugo Sánchez won the La Liga Pichichi top scorer award five consecutive times from 1984–85 to 1989–90, a record unmatched until Messi. He scored 208 goals in La Liga.'),

  (v_league, v_fp, 'Andrés Iniesta spent his entire career at FC Barcelona before moving to which club in 2018?',
   '["Juventus","Inter Milan","Vissel Kobe","New York City FC"]', 2, 'medium',
   'Andrés Iniesta joined Vissel Kobe in Japan''s J. League in May 2018 after 22 years at FC Barcelona, where he won 32 trophies including 4 Champions Leagues and 9 La Liga titles.'),

  (v_league, v_fp, 'Which La Liga player famously scored "La Zapatilla" (The Slipper) goal, a backheel finish that became iconic?',
   '["Thierry Henry","Zlatan Ibrahimović","Hugo Sánchez","Emilio Butragueño"]', 2, 'hard',
   'Hugo Sánchez was famous for his acrobatic overhead kicks and spectacular finishes at Real Madrid. His goals were renowned for their technical brilliance throughout La Liga in the 1980s.'),

  (v_league, v_fp, 'Samuel Eto''o won the African Player of the Year award four times while playing in La Liga for which club?',
   '["Atlético de Madrid","Real Madrid","FC Barcelona","Sevilla"]', 2, 'medium',
   'Samuel Eto''o spent five seasons at FC Barcelona (2004–2009) and won the Champions League twice. He won the African Player of the Year award four times, including during his Barcelona years.'),

  (v_league, v_fp, 'Which Portuguese winger joined Real Madrid in 2009 for a then world record fee of €94 million?',
   '["Luis Figo","Cristiano Ronaldo","Nani","Ricardo Quaresma"]', 1, 'easy',
   'Cristiano Ronaldo joined Real Madrid from Manchester United for €94 million in June 2009, breaking the world transfer record at the time. He went on to score 450 goals for the club in all competitions.'),

  (v_league, v_fp, 'Luis Suárez had a remarkable debut La Liga season in 2014–15 despite serving a ban. How many goals did he score?',
   '["16","20","25","29"]', 2, 'hard',
   'Luis Suárez scored 25 La Liga goals in 2014–15 despite missing the first 11 games due to his FIFA ban following the biting incident at the 2014 World Cup. He won La Liga and the Champions League in his first full season.'),

  (v_league, v_fp, 'Gareth Bale joined Real Madrid in 2013. What was unusual about many of his injury absences?',
   '["He blamed the training pitch","He was said to prefer golf to football","He was frequently criticised for muscle injuries","All of the above were reported"]', 3, 'medium',
   'Gareth Bale became a controversial figure at Real Madrid, with Spanish media frequently criticising him for prioritising golf and for injury absences. Despite this, he won 4 Champions Leagues and 2 La Liga titles.'),

  (v_league, v_fp, 'Which Brazilian right-back at Real Madrid was famous for his powerful free kicks and attacking runs in the 1990s–2000s?',
   '["Cafu","Maicon","Roberto Carlos","Gilberto Silva"]', 2, 'easy',
   'Roberto Carlos spent 11 seasons at Real Madrid (1996–2007) and became famous for his bending free kick against France in 1997 — a goal that left physicists baffled. He won 4 La Liga titles and 3 Champions Leagues.'),

  (v_league, v_fp, 'Who is Atlético de Madrid''s all-time top scorer, with over 120 goals for the club as both player and beloved manager?',
   '["Fernando Torres","Diego Forlán","Radamel Falcao","Luis Aragonés"]', 3, 'hard',
   'Luis Aragonés scored 123 official goals for Atlético de Madrid and is the club''s all-time top scorer. He later managed the club and went on to lead Spain to their historic Euro 2008 triumph, launching a golden era for Spanish football.'),

  (v_league, v_fp, 'Which La Liga player was known as "The Phenomenon" for his extraordinary physical gifts and goals?',
   '["Ronaldinho","Ronaldo Nazário","Rivaldo","Robinho"]', 1, 'easy',
   'Ronaldo Nazário — "R9" — was nicknamed "The Phenomenon" for his extraordinary speed, strength, and goalscoring. He scored 34 goals in 37 La Liga games for Barcelona in 1996–97 before injury and Barça disputes led to his departure.'),

  (v_league, v_fp, 'Xavi Hernández began his managerial career at which club before returning to FC Barcelona?',
   '["Vissel Kobe","Al-Sadd","Sporting CP","Aston Villa"]', 1, 'medium',
   'Xavi became manager of Al-Sadd in Qatar in 2019, winning the Qatar Stars League before returning to FC Barcelona as manager in November 2021. He guided Barça to La Liga in 2022–23.'),

  (v_league, v_fp, 'Which Real Madrid forward scored 50 goals in the 2011–12 La Liga season, a competition record?',
   '["Karim Benzema","Gonzalo Higuaín","Cristiano Ronaldo","Ángel Di María"]', 2, 'medium',
   'Cristiano Ronaldo scored 50 La Liga goals in the 2011–12 season, the most in a single La Liga season. Real Madrid won the title with a then record 100 points and 121 goals.'),

  (v_league, v_fp, 'Which left-footed Barcelona forward is remembered for his role in the 2011 Champions League Final against Manchester United?',
   '["Pedro","Villa","Messi","Iniesta"]', 2, 'medium',
   'Lionel Messi''s goal — a chip over Edwin van der Sar — was the iconic moment of Barcelona''s 3–1 win over Manchester United in the 2011 Champions League Final at Wembley.'),

  (v_league, v_fp, 'Karim Benzema won the 2022 Ballon d''Or. Which country does he represent internationally?',
   '["Algeria","Morocco","France","Tunisia"]', 2, 'easy',
   'Karim Benzema is French, born in Lyon to Algerian parents. He won the 2022 Ballon d''Or after a remarkable individual season at Real Madrid, scoring 44 goals across all competitions.'),

  (v_league, v_fp, 'Which Spanish midfielder left FC Barcelona for Arsenal in 2011 before eventually returning to Spain?',
   '["Xavi","Iniesta","Cesc Fàbregas","Sergio Busquets"]', 2, 'easy',
   'Cesc Fàbregas left Arsenal for FC Barcelona in 2011, returning to the club he left at age 16. He later played for Chelsea and AS Monaco before ending his career in Italy.'),

  (v_league, v_fp, 'Vinicius Jr plays for Real Madrid and which national team?',
   '["Argentina","Portugal","Brazil","Spain"]', 2, 'easy',
   'Vinicius Jr represents Brazil internationally and joined Real Madrid from Flamengo for €45 million in 2018, aged 18. He has since become one of the world''s best players, winning La Liga and the Champions League.');

  -- ============================================================
  -- EL CLÁSICO (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_ec, 'How many El Clásico matches have been played in total (La Liga only) between Real Madrid and Barcelona?',
   '["Around 100","Around 150","Around 200","Around 250"]', 3, 'hard',
   'By 2024, Real Madrid and Barcelona had played approximately 250 La Liga Clásicos, with Real Madrid winning around 100 and Barcelona winning around 97, the rest being draws.'),

  (v_league, v_ec, 'The biggest ever El Clásico victory was Real Madrid 11–1 Barcelona in which year?',
   '["1931","1943","1953","1960"]', 1, 'hard',
   'Real Madrid beat Barcelona 11–1 in La Liga in June 1943 — a match played during the Franco dictatorship under circumstances widely considered to be politically influenced.'),

  (v_league, v_ec, 'In the 2014 Copa del Rey Final, Real Madrid beat Barcelona 2–1 after extra time. Who scored the winner?',
   '["Gareth Bale","Cristiano Ronaldo","Benzema","Marcelo"]', 0, 'medium',
   'Gareth Bale scored a stunning long-range winner in the Copa del Rey Final against Barcelona at the Mestalla in May 2014, after an extraordinary run down the left wing outpacing Barça''s defence.'),

  (v_league, v_ec, 'In the 2009 La Liga season, Barcelona beat Real Madrid 6–2 at the Bernabéu. Who scored a hat-trick for Barça?',
   '["Xavi","Thierry Henry","Lionel Messi","Pedro"]', 2, 'hard',
   'Lionel Messi scored a hat-trick in Barcelona''s famous 6–2 win at the Bernabéu in May 2009. It was a statement of Pep Guardiola''s side''s dominance — they went on to win the Treble that season.'),

  (v_league, v_ec, 'Who won the most El Clásicos as a player — Messi or Ronaldo?',
   '["Messi (28 wins)","Ronaldo (28 wins)","They won exactly the same","Messi (25 wins)"]', 0, 'hard',
   'Lionel Messi won more El Clásicos than Cristiano Ronaldo during their overlapping careers at Barcelona and Real Madrid respectively. Messi also scored more Clásico goals (26 vs 18).'),

  (v_league, v_ec, 'In which city is the Copa del Rey El Clásico Final traditionally held when the two clubs meet?',
   '["Madrid","Barcelona","A neutral venue","Seville"]', 2, 'medium',
   'Copa del Rey Finals are held at a neutral venue, typically a large Spanish stadium. The 2014 final (Gareth Bale''s goal) was at the Mestalla in Valencia; the 2011 final was at the Mestalla too.'),

  (v_league, v_ec, 'In the April 2016 El Clásico, Messi scored a dramatic 90th-minute winner at the Bernabéu and celebrated by revealing a message on his undershirt. What did it say?',
   '["For my children","For my mother","I love you grandma","For my city"]', 2, 'hard',
   'Messi scored in the 90th minute of the April 2016 El Clásico to make it 3–2 to Barcelona at the Bernabéu. He then removed his shirt to reveal the words "I love you grandma" in dedication to his late grandmother Celia.'),

  (v_league, v_ec, 'Luis Figo''s transfer from Barcelona to Real Madrid in 2000 caused a major scandal. What famously happened when he returned to Camp Nou?',
   '["He was cheered loudly","A pig''s head was thrown at him","He refused to take corners","He was given a standing ovation"]', 1, 'medium',
   'When Luis Figo returned to Camp Nou as a Real Madrid player, Barcelona fans pelted him with various objects including a pig''s head during a corner kick — one of football''s most infamous moments.'),

  (v_league, v_ec, 'José Mourinho managed Real Madrid from 2010 to 2013. What is his El Clásico win record?',
   '["6 wins","8 wins","10 wins","12 wins"]', 1, 'hard',
   'José Mourinho won 8 El Clásicos (across La Liga, Copa del Rey, and Champions League) as Real Madrid manager from 2010 to 2013, including famous cup wins against Barcelona.'),

  (v_league, v_ec, 'The phrase "The Match of the Century" has been applied to which El Clásico?',
   '["The 1-11 in 1943","The 2006 Champions League Semi-Final","Various Clásicos over the years","No such phrase has been used"]', 2, 'medium',
   '"The Match of the Century" is a title given to many classic encounters. Various El Clásicos — especially those in the Champions League — have been hyped with this label over the decades.'),

  (v_league, v_ec, 'Which former Barcelona player managed Real Madrid and faced Barça in El Clásico during the 1990s?',
   '["Johan Cruyff","John Toshack","Leo Beenhakker","Jupp Heynckes"]', 1, 'hard',
   'John Toshack managed Real Madrid but never played for Barcelona. Jorge Valdano and Fabio Capello had notable Real Madrid managerial stints. Cruyff''s connection was as a Barcelona player/manager.'),

  (v_league, v_ec, 'Ronaldo (R9) scored a famous hat-trick at Camp Nou. What was the crowd''s reaction?',
   '["They booed him","They gave him a standing ovation","They threw objects","They chanted Messi''s name"]', 1, 'medium',
   'Ronaldo Nazário scored a hat-trick for Real Madrid at Camp Nou in April 2002 (Champions League semi-final), and Barcelona fans gave him a standing ovation — a remarkable show of respect for greatness.'),

  (v_league, v_ec, 'Which El Clásico of 2011 saw four matches played between the clubs in 18 days?',
   '["La Liga, Copa del Rey, Champions League (x2)","La Liga (x2), Copa del Rey, Champions League","La Liga, Copa del Rey (x2), Champions League","La Liga, UEFA Super Cup, Copa del Rey, Champions League"]', 0, 'medium',
   'In April–May 2011, Real Madrid and Barcelona played four times in 18 days: La Liga, Copa del Rey Final, and the Champions League semi-final (two legs). Barcelona won 3 of the 4 matches.'),

  (v_league, v_ec, 'Which manager''s tactical approach of pressing and positional play made his El Clásico win record extraordinary (7 wins in 16)?',
   '["Jose Mourinho","Pep Guardiola","Louis van Gaal","Frank Rijkaard"]', 1, 'medium',
   'Pep Guardiola''s Barcelona teams had an extraordinary record against Real Madrid, with his possession-based style often overwhelming Madrid in La Liga and European competition.'),

  (v_league, v_ec, 'El Clásico in the 2021–22 Champions League quarter-final second leg saw Real Madrid score three goals in the last 30 minutes. What was the score?',
   '["3–1","3–0","3–2","4–3"]', 0, 'hard',
   'Real Madrid beat Barcelona 3–0 in the Champions League quarter-final second leg in April 2022 at the Bernabéu, with Karim Benzema inspiring an extraordinary comeback after trailing 0–1 at the break.'),

  (v_league, v_ec, 'Who scored the fastest goal in El Clásico history?',
   '["Cristiano Ronaldo","Gareth Bale","Ronaldo Nazário","Pedro"]', 0, 'hard',
   'Cristiano Ronaldo scored within 90 seconds in an El Clásico at the Bernabéu in 2012, one of the fastest goals in the fixture''s history.'),

  (v_league, v_ec, 'Which season''s El Clásico is nicknamed "the last great Clásico" before the COVID era?',
   '["2018–19","2019–20","2020–21","2017–18"]', 0, 'hard',
   'The October 2018 and March 2019 Clásicos of 2018–19 were among the most anticipated before COVID affected attendance and atmosphere in the 2019–20 and 2020–21 seasons.'),

  (v_league, v_ec, 'How many El Clásicos did Messi and Ronaldo play against each other directly (all competitions)?',
   '["22","24","26","30"]', 2, 'medium',
   'Messi and Ronaldo faced each other in 26 El Clásico matches (across all competitions) between 2009 and 2018. Messi''s teams won 16 of those encounters.'),

  (v_league, v_ec, 'A Clásico in the Copa del Rey final at the Bernabéu in 2011 was won by which club?',
   '["Real Madrid 1–0 Barcelona","Barcelona 1–0 Real Madrid","Barcelona 2–0 Real Madrid","Real Madrid 2–0 Barcelona"]', 1, 'hard',
   'Barcelona beat Real Madrid 1–0 in the Copa del Rey final at the Mestalla in Valencia in April 2011, with Adriano scoring the only goal.'),

  (v_league, v_ec, 'Which El Clásico saw Messi score a famous bicycle kick in April 2018?',
   '["The Champions League quarter-final second leg","The La Liga Clásico at the Bernabéu","The Copa del Rey semi-final","No such goal was scored"]', 0, 'medium',
   'Messi scored an extraordinary bicycle kick at the Juventus Stadium in April 2018 (Champions League quarter-final), but at the Bernabéu he scored a bicycle kick in La Liga in April 2018 to win the match.'),

  (v_league, v_ec, 'Real Madrid''s 5–0 win over Barcelona in the 1994–95 La Liga was notable for goals from which striker?',
   '["Hugo Sánchez","Ronaldo","Ivan Zamorano","Fernando Hierro"]', 2, 'hard',
   'Ivan Zamorano scored in Real Madrid''s famous "Manita" (5–0) win over Barcelona in 1994–95. Real Madrid have achieved several 5–0 wins over Barça during their rivalry''s history.'),

  (v_league, v_ec, 'What term is used when one team beats the other in El Clásico by 5 goals or more?',
   '["Goleada","Manita","Golazo","Remontada"]', 1, 'medium',
   '"Manita" (literally "little hand") refers to when a team holds up five fingers to celebrate a 5–0 or 5-goal margin victory. Real Madrid and Barcelona have each inflicted a "manita" on the other.'),

  (v_league, v_ec, 'Who is the highest scoring player in El Clásico history?',
   '["Cristiano Ronaldo","Raúl","Hugo Sánchez","Lionel Messi"]', 3, 'easy',
   'Lionel Messi has scored 26 La Liga Clásico goals — more than any other player in the fixture''s history. Cristiano Ronaldo is second with 18 goals.'),

  (v_league, v_ec, 'The 2022 El Clásico at the Camp Nou in March saw Barcelona win 4–0. Who scored twice?',
   '["Pedri","Pierre-Emerick Aubameyang","Ferran Torres","Ousmane Dembélé"]', 1, 'hard',
   'Pierre-Emerick Aubameyang scored twice in Barcelona''s 4–0 demolition of Real Madrid at Camp Nou in March 2022 — one of the most emphatic Clásico wins in recent memory, with Madrid having won La Liga 12 points later.'),

  (v_league, v_ec, 'Which referee controversially sent off a Barcelona player during a heated El Clásico at the Bernabéu?',
   '["Pierluigi Collina","Eduardo Iturralde","Velasco Carballo","Xavier Estrada Fernández"]', 2, 'hard',
   'El Clásico controversies around refereeing decisions have been a recurring theme. Velasco Carballo controversially sent off Sergio Busquets in the 2011 Copa del Rey Final, and red card decisions have fuelled countless post-match debates.'),

  (v_league, v_ec, 'The term "La Remontada" (The Comeback) in El Clásico context is used most for which result?',
   '["Barcelona 6-0 PSG in Champions League","Barcelona 4-0 Real Madrid in Copa del Rey semi-final","Real Madrid 2-1 Barcelona in Champions League","Barcelona 4-0 Real Madrid in Champions League"]', 0, 'hard',
   '"La Remontada" specifically refers to Barcelona''s Champions League comeback against PSG in 2017 (6–1 after losing the first leg 4–0), not an El Clásico, though dramatic Clásico comebacks also use the term.'),

  (v_league, v_ec, 'Who scored a famous header in El Clásico that was later used in a Pepsi advertising campaign?',
   '["Ronaldo Nazário","Ronaldinho","Samuel Eto''o","Carles Puyol"]', 2, 'hard',
   'Ronaldinho''s brilliant play and goals during El Clásicos in 2004–06 made him a global icon, used extensively in Pepsi advertisements during this period.'),

  (v_league, v_ec, 'Real Madrid''s biggest ever home win over Barcelona in La Liga is which result?',
   '["8–2","7–2","6–1","5–0"]', 0, 'hard',
   'Real Madrid beat Barcelona 8–2 in the La Liga Clásico in February 1935 at the Bernabéu — their biggest ever home win in the fixture. The match was played during the Second Spanish Republic era.'),

  (v_league, v_ec, 'The 2011 Champions League semi-final between the two clubs ended with which aggregate score?',
   '["Barcelona 2-0 Real Madrid (agg)","Barcelona 3-1 Real Madrid (agg)","Real Madrid 3-1 Barcelona (agg)","2-2 (Barça through on away goals)"]', 1, 'hard',
   'Barcelona beat Real Madrid 3–1 on aggregate (2–0 in the first leg at Camp Nou, 1–1 in the second leg at the Bernabéu) in the 2011 Champions League semi-final.'),

  (v_league, v_ec, 'Which iconic El Clásico moment involved a goalkeeper throwing himself to the wrong side for a Messi penalty?',
   '["The Panenka penalty by Messi in 2012","Iker Casillas diving wrong in 2010","Diego López diving wrong in 2014","The 2017 dribble into goal"]', 2, 'hard',
   'Diego López dived the wrong way for Messi''s penalty in El Clásico in March 2014, summing up the difficulty of facing Messi. Casillas also went the wrong way for several Messi penalties during their careers.'),

  (v_league, v_ec, 'What is the traditional outcome prediction site fans use before El Clásico, known for its statistical previews?',
   '["WhoScored","Opta","FBref","All are used equally"]', 3, 'hard',
   'Fans and journalists use Opta, WhoScored, and FBref interchangeably for pre-Clásico statistics. Opta''s data is particularly widely cited by Spanish media in the build-up to El Clásico.');

  -- ============================================================
  -- RECORDS & STATS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_rs, 'What is the record for most goals scored in a single La Liga season?',
   '["41","46","50","55"]', 2, 'medium',
   'Cristiano Ronaldo scored 50 La Liga goals in the 2011–12 season for Real Madrid — a La Liga record. Real Madrid also set records for points (100) and goals (121) that same season.'),

  (v_league, v_rs, 'How many goals did Lionel Messi score in La Liga total throughout his career at Barcelona?',
   '["420","447","474","498"]', 2, 'easy',
   'Lionel Messi scored 474 La Liga goals for FC Barcelona between his debut in 2004 and his departure in 2021, a record that may never be beaten in Spain''s top flight.'),

  (v_league, v_rs, 'Real Madrid won La Liga with a record 100 points in which season?',
   '["2010–11","2011–12","2012–13","2013–14"]', 1, 'medium',
   'Real Madrid won the 2011–12 La Liga with 100 points — a record — beating Barcelona by 9 points. They scored 121 goals with Ronaldo contributing 50 of them.'),

  (v_league, v_rs, 'Which La Liga season saw the highest number of goals scored by a club in a single campaign?',
   '["Real Madrid 2011–12 (121 goals)","Barcelona 2010–11 (95 goals)","Real Madrid 2014–15 (118 goals)","Atlético de Madrid 2014–15 (67 goals)"]', 0, 'medium',
   'Real Madrid scored 121 La Liga goals in the 2011–12 season — a La Liga record. Ronaldo (50), Benzema (21), and Higuaín (22) were the main contributors.'),

  (v_league, v_rs, 'Which goalkeeper won the Ricardo Zamora Trophy (best keeper) the most times?',
   '["Victor Valdés","Iker Casillas","Andoni Zubizarreta","Santiago Cañizares"]', 1, 'medium',
   'Iker Casillas won the Ricardo Zamora Trophy five times — more than any other goalkeeper in La Liga history. The award is named after Ricardo Zamora, Spain''s legendary 1920s–30s keeper.'),

  (v_league, v_rs, 'Lionel Messi won the Pichichi (La Liga top scorer) award how many times?',
   '["5","6","7","8"]', 3, 'hard',
   'Lionel Messi won the La Liga Pichichi top scorer award eight times (2009–10, 2011–12, 2012–13, 2016–17, 2017–18, 2018–19, 2019–20, 2020–21), more than any other player in history.'),

  (v_league, v_rs, 'How many consecutive La Liga titles did Barcelona win under Pep Guardiola (2008–12)?',
   '["2","3","4","5"]', 1, 'medium',
   'Barcelona won three consecutive La Liga titles from 2009–10 to 2011–12 under Pep Guardiola — though Real Madrid''s record 100-point season in 2011–12 was also set in this period when they finally broke Barça''s run.'),

  (v_league, v_rs, 'What is the record for most consecutive La Liga titles won by a single club?',
   '["3","4","5","6"]', 1, 'hard',
   'Barcelona won four consecutive La Liga titles from 2012–13 to 2015–16, the longest consecutive run in the modern La Liga era.'),

  (v_league, v_rs, 'What was the record number of goals scored by La Liga''s top scorer in the 2022–23 season?',
   '["22","23","26","28"]', 2, 'hard',
   'Robert Lewandowski won the La Liga Pichichi in 2022–23 with 23 goals in his debut season at FC Barcelona — a strong return that also helped Barcelona win the La Liga title.'),

  (v_league, v_rs, 'How many clubs have been relegated from La Liga 1 (top flight) and returned to win it?',
   '["None — relegated clubs have never won it upon return","Several clubs including Deportivo","Only one — Atlético in the 1930s","This has never been tracked"]', 1, 'hard',
   'Several clubs relegated and returned have won La Liga. Most notably, Atlético de Madrid were briefly relegated in 1930 and came back strong. In modern times, Deportivo de La Coruña and Valencia have been promoted and later won titles.'),

  (v_league, v_rs, 'What is the largest winning margin in La Liga history in a single match?',
   '["10–0","11–1","12–1","13–0"]', 1, 'hard',
   'Real Madrid''s 11–1 victory over Barcelona in 1943 is the largest scoreline in La Liga history. However, that era was controversial due to political circumstances in Franco''s Spain.'),

  (v_league, v_rs, 'How many different clubs have won La Liga?',
   '["9","10","11","12"]', 0, 'hard',
   'Nine different clubs have won La Liga: Real Madrid, Barcelona, Atlético de Madrid, Athletic Club, Valencia, Real Sociedad, Sevilla, Deportivo de La Coruña, and Betis (though Betis only won in 1934–35).'),

  (v_league, v_rs, 'Which was the first season La Liga used the Video Assistant Referee (VAR) technology?',
   '["2016–17","2017–18","2018–19","2019–20"]', 2, 'medium',
   'La Liga introduced VAR for the 2018–19 season, becoming one of the first major European leagues to implement the technology league-wide following its use in the 2018 FIFA World Cup.'),

  (v_league, v_rs, 'Lionel Messi scored in how many consecutive La Liga matches during his record streak in 2012–13?',
   '["14","16","19","21"]', 2, 'hard',
   'Lionel Messi scored in 21 consecutive La Liga matches during the 2012–13 season — a La Liga record for consecutive matches scored in.'),

  (v_league, v_rs, 'Real Madrid''s total Champions League wins make them the most successful club in European competition. How many as of 2024?',
   '["13","14","15","16"]', 2, 'easy',
   'Real Madrid won their 15th UEFA Champions League in June 2022 (beating Liverpool) and their record 15th title. They also won the 2023–24 Champions League, bringing the total to 15 confirmed as of late 2024.'),

  (v_league, v_rs, 'How many clubs compete in La Liga each season?',
   '["16","18","20","22"]', 2, 'easy',
   'La Liga has consisted of 20 clubs competing across a 38-match season since 1995. Three clubs are relegated and replaced by three from La Liga 2 at the end of each season.'),

  (v_league, v_rs, 'Which La Liga club holds the record for the most consecutive seasons without relegation?',
   '["Real Madrid","FC Barcelona","Athletic Club","Valencia CF"]', 2, 'easy',
   'Athletic Club de Bilbao have never been relegated from La Liga since the competition''s first season in 1929 — an unbroken run of top-flight football spanning nearly 100 years.'),

  (v_league, v_rs, 'How many goals per game on average did La Liga produce in the 2022–23 season?',
   '["2.3","2.5","2.7","2.9"]', 2, 'hard',
   'La Liga averaged approximately 2.7 goals per game in the 2022–23 season across 380 matches, slightly lower than the Premier League''s average but still producing exciting football.'),

  (v_league, v_rs, 'Which La Liga club was the first to win the league five consecutive times?',
   '["FC Barcelona","Real Madrid","Athletic Club","Atlético de Madrid"]', 1, 'hard',
   'Real Madrid won La Liga five consecutive times from 1961–62 to 1964–65. No club had achieved such a run before in the competition''s history.'),

  (v_league, v_rs, 'The "Trofeo Pichichi" is named after who?',
   '["A Spanish king","An Athletic Club striker from the 1920s","A referee who reformed the league","A journalist who tracked goals"]', 1, 'medium',
   'The Pichichi Trophy is named after Rafael Moreno "Pichichi," an Athletic Club forward who died in 1922. He was renowned for his goalscoring and was one of La Liga''s first great strikers.'),

  (v_league, v_rs, 'How many points did Barcelona finish with in their record-breaking 2009–10 La Liga season?',
   '["96","99","100","102"]', 1, 'hard',
   'Barcelona won the 2009–10 La Liga with 99 points — a then La Liga record. They scored 98 goals under Pep Guardiola in one of the most dominant title wins in league history.'),

  (v_league, v_rs, 'Which La Liga club was the first to score 100+ goals in a single La Liga season?',
   '["FC Barcelona","Real Madrid","Athletic Club","Valencia CF"]', 1, 'medium',
   'Real Madrid scored 121 goals in the 2011–12 La Liga season — the first club in La Liga history to exceed 100 goals in a single season.'),

  (v_league, v_rs, 'Messi''s free kick conversion rate in La Liga was remarkable. How many direct free kicks did he score for Barça?',
   '["28","35","41","50"]', 2, 'hard',
   'Lionel Messi scored 41 direct free kick goals in La Liga for FC Barcelona — the most by any player in La Liga history from set pieces.'),

  (v_league, v_rs, 'Which team won La Liga in 2020–21 under Diego Simeone?',
   '["Atlético de Madrid","Real Madrid","FC Barcelona","Villarreal"]', 0, 'easy',
   'Atlético de Madrid, managed by Diego Simeone, won the 2020–21 La Liga title on the final day of the season, edging out Real Madrid by two points in a tense title race.'),

  (v_league, v_rs, 'The FIFA Club World Cup has been won most often by which La Liga club?',
   '["FC Barcelona","Atlético de Madrid","Real Madrid","Sevilla"]', 2, 'medium',
   'Real Madrid have won the FIFA Club World Cup (formerly Intercontinental Cup) the most times of any Spanish club, winning in 2014, 2016, 2017, 2018, and 2022.'),

  (v_league, v_rs, 'Which season saw Atlético de Madrid achieve their historic league and cup double?',
   '["1995–96","1999–2000","2012–13","2013–14"]', 3, 'medium',
   'Atlético de Madrid won the La Liga and Copa del Rey double in 1995–96 under Raddy Antic, and again in 2012–13 won the Copa del Rey. Their 2013–14 title under Simeone came without a cup double.'),

  (v_league, v_rs, 'How many penalties did Messi score in La Liga during his career at Barcelona?',
   '["52","64","76","91"]', 2, 'hard',
   'Lionel Messi scored 76 penalties in La Liga for FC Barcelona across 17 seasons — a mix of his natural tendency to earn spot-kicks and his accuracy from 12 yards.'),

  (v_league, v_rs, 'Which La Liga season saw a record 496 goals scored in the competition?',
   '["2011–12","2014–15","2018–19","2022–23"]', 0, 'hard',
   'The 2011–12 La Liga season saw a then-record 1,022 goals across 380 matches — driven largely by Cristiano Ronaldo''s 50-goal haul and Real Madrid''s 121-goal season.'),

  (v_league, v_rs, 'Real Madrid have won the Champions League more times than any other club. How many times have they won it as of 2024?',
   '["13","14","15","16"]', 2, 'easy',
   'Real Madrid won their 15th Champions League in 2024, defeating Borussia Dortmund 2–0 in the final at Wembley, confirming their status as European football''s most successful club.'),

  (v_league, v_rs, 'Which is the lowest-ever winning points total for a La Liga champion?',
   '["38","43","47","50"]', 2, 'hard',
   'In early La Liga seasons played with 2 points for a win, the points totals were naturally lower. In the modern 3-points era (since 1995), the lowest La Liga title-winning total was around 70 points for Deportivo de La Coruña in 1999–2000.');

  -- ============================================================
  -- MANAGERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_mg, 'Which manager won La Liga in his first season at Real Madrid in 2021–22?',
   '["Zinedine Zidane","Julen Lopetegui","Carlo Ancelotti","José Mourinho"]', 2, 'easy',
   'Carlo Ancelotti won La Liga and the Champions League in his first full season back at Real Madrid in 2021–22. It was his second stint as Madrid manager after his 2013–15 spell.'),

  (v_league, v_mg, 'Pep Guardiola won La Liga how many times as Barcelona manager?',
   '["2","3","4","5"]', 1, 'medium',
   'Pep Guardiola won La Liga three times during his four-season tenure at FC Barcelona (2008–12), losing it to Real Madrid''s record 100-point season in 2011–12.'),

  (v_league, v_mg, 'Which manager is associated with the "counter-attacking" style that made Atlético de Madrid a title contender?',
   '["Javier Aguirre","Raddy Antic","Diego Simeone","Carlos Bianchi"]', 2, 'easy',
   'Diego Simeone became Atlético de Madrid manager in December 2011 and transformed them into La Liga champions (2013–14, 2020–21), Champions League finalists (2014, 2016), and European royalty.'),

  (v_league, v_mg, 'Johan Cruyff managed FC Barcelona from 1988 to 1996. What was his managerial philosophy?',
   '["Route one football","Total Football and positional play","Counter-attacking defence","High press and direct play"]', 1, 'medium',
   'Johan Cruyff implemented Total Football philosophy at Barcelona, emphasising positional awareness, technical ability, and attacking play. His work laid the foundations for the tiki-taka era.'),

  (v_league, v_mg, 'Zinedine Zidane won how many Champions League titles as Real Madrid manager?',
   '["1","2","3","4"]', 2, 'easy',
   'Zinedine Zidane won three consecutive Champions League titles as Real Madrid manager (2015–16, 2016–17, 2017–18) — an unprecedented feat in the modern Champions League era.'),

  (v_league, v_mg, 'Which manager guided Valencia to two La Liga titles in 2001–02 and 2003–04?',
   '["Héctor Cúper","Rafael Benítez","Claudio Ranieri","Javier Irureta"]', 1, 'medium',
   'Rafael Benítez managed Valencia to two La Liga titles (2001–02 and 2003–04), establishing them as one of Europe''s top clubs before leaving for Liverpool where he won the Champions League in 2005.'),

  (v_league, v_mg, 'José Mourinho famously poked Tito Vilanova in the eye in El Clásico. Which year did this happen?',
   '["2009","2011","2012","2013"]', 1, 'hard',
   'Mourinho poked Barcelona assistant coach Tito Vilanova in the eye during a touchline confrontation at the end of the Supercopa de España in August 2011 — one of football''s most infamous incidents.'),

  (v_league, v_mg, 'Which manager took Barcelona to the Champions League title in 2005–06 and 2008–09?',
   '["Louis van Gaal","Johan Cruyff","Frank Rijkaard","Pep Guardiola"]', 2, 'medium',
   'Frank Rijkaard guided Barcelona to La Liga in 2004–05 and 2005–06, and the Champions League in 2005–06. Pep Guardiola then won the Champions League in 2008–09.'),

  (v_league, v_mg, 'Vicente del Bosque won La Liga and the Champions League with Real Madrid before guiding which national team to World Cup glory?',
   '["Brazil","Argentina","Spain","France"]', 2, 'easy',
   'Vicente del Bosque managed Spain to World Cup glory in 2010 and Euro 2012, completing the trophy set after also guiding Real Madrid to two Champions League titles (1999–2000, 2001–02) and two La Liga titles.'),

  (v_league, v_mg, 'Which former Barcelona youth-team player became their manager and won La Liga in 2022–23?',
   '["Pep Guardiola","Ernesto Valverde","Quique Setién","Xavi Hernández"]', 3, 'medium',
   'Xavi Hernández was appointed FC Barcelona manager in November 2021 and won La Liga in 2022–23, his first full season in charge. He had played for the club from 1998 to 2015.'),

  (v_league, v_mg, 'Which manager took Sevilla to three consecutive Europa League titles (2014, 2015, 2016)?',
   '["Unai Emery","Quique Flores","Maurizio Sarri","Michel"]', 0, 'medium',
   'Unai Emery guided Sevilla to three consecutive UEFA Europa League titles between 2014 and 2016 — the most successful run by any manager in European club competition history.'),

  (v_league, v_mg, 'Which La Liga manager is known for his intense touchline celebrations and emotional engagement?',
   '["Ernesto Valverde","Diego Simeone","Quique Setién","Pepe Mel"]', 1, 'medium',
   'Diego Simeone''s passionate touchline presence — fist pumps, sprint celebrations, constant communication with his players — has made him one of the most recognisable managers in world football.'),

  (v_league, v_mg, 'Which manager won La Liga five consecutive times with Real Madrid in the 1960s?',
   '["Miguel Muñoz","José Villalonga","Molowny","Luis Carniglia"]', 0, 'hard',
   'Miguel Muñoz managed Real Madrid during one of their most dominant periods, winning La Liga five times. As a player, he had also been part of the European Cup-winning squads in the 1950s.'),

  (v_league, v_mg, 'Arsène Wenger spent time at which Spanish club early in his coaching career?',
   '["No — he never managed in Spain","Cannes","Barcelona reserves","Racing Club de Strasbourg"]', 0, 'hard',
   'Arsène Wenger never managed in La Liga. He managed in France (Nancy, Monaco) and Japan (Nagoya Grampus) before joining Arsenal. His association with Spanish football is purely as a tactical admirer.'),

  (v_league, v_mg, 'Which non-Spanish manager took Deportivo de La Coruña to their only La Liga title in 2000?',
   '["Hector Cúper","Javier Irureta","Victor Fernández","Lothar Matthäus"]', 1, 'medium',
   'Javier Irureta, a Spanish Basque manager, guided Deportivo de La Coruña to their only La Liga title in 1999–2000, one of the biggest surprise title wins in La Liga history.'),

  (v_league, v_mg, 'Which manager introduced the famous 4-3-3 formation that became synonymous with Barcelona?',
   '["Johan Cruyff","Johan Neeskens","Rinus Michels","Pep Guardiola"]', 0, 'medium',
   'Johan Cruyff introduced the 4-3-3 formation at Barcelona as manager, adapting the principles of Rinus Michels'' Total Football into a Spanish context that prioritised ball possession and positional play.'),

  (v_league, v_mg, 'Marcelo Bielsa managed which La Liga club in 2011–13 with his intense pressing philosophy?',
   '["Sevilla","Athletic Club","Real Sociedad","Málaga"]', 1, 'medium',
   'Marcelo Bielsa managed Athletic Club de Bilbao from 2011 to 2013, reaching the Europa League Final and Copa del Rey Final in his first season while maintaining their Basque-only player policy.'),

  (v_league, v_mg, 'Quique Sánchez Flores managed which Madrid club and led them to the Europa League title?',
   '["Real Madrid","Atlético de Madrid","Getafe CF","Rayo Vallecano"]', 1, 'hard',
   'Quique Sánchez Flores managed Atlético de Madrid to the 2009–10 UEFA Europa League title, beating Fulham 2–1 in the final in Hamburg. He also managed the national team Getafe and other clubs.'),

  (v_league, v_mg, 'Carlo Ancelotti was sacked by Real Madrid in 2015 but returned in which year?',
   '["2019","2020","2021","2022"]', 2, 'medium',
   'Carlo Ancelotti was sacked by Real Madrid in May 2015 after losing the Copa del Rey Final to Barcelona. He returned in June 2021 and immediately won La Liga and the Champions League.'),

  (v_league, v_mg, 'Which manager is credited with developing Barcelona''s famous "La Masia" academy philosophy?',
   '["Johan Cruyff","Pep Guardiola","Louis van Gaal","Frank Rijkaard"]', 0, 'medium',
   'Johan Cruyff established the philosophical framework for FC Barcelona''s La Masia academy, insisting on technical and positional play from youth level. Players like Messi, Xavi, and Iniesta were products of this system.'),

  (v_league, v_mg, 'Unai Emery managed PSG, Sevilla, Arsenal, Villarreal, and Aston Villa. At which club did he win a European trophy?',
   '["Sevilla","PSG","Arsenal","Villarreal"]', 0, 'medium',
   'Unai Emery won three consecutive UEFA Europa Leagues with Sevilla (2014, 2015, 2016). He also won the Europa League with Villarreal in 2021, defeating Manchester United on penalties.'),

  (v_league, v_mg, 'Which former Real Madrid player managed rivals Barcelona between 2002 and 2003?',
   '["Bernd Schuster","Louis van Gaal","Radomir Antić","No Real Madrid player ever managed Barcelona"]', 2, 'hard',
   'Radomir Antić is the only man to have managed Real Madrid, Barcelona, and Atlético de Madrid. He managed Barça in 2002–03 before being sacked and replaced by Frank Rijkaard.'),

  (v_league, v_mg, 'Luís Enrique won the Treble with Barcelona in 2014–15. Where was he born?',
   '["Catalonia, Spain","Madrid, Spain","Asturias, Spain","Andalusia, Spain"]', 2, 'medium',
   'Luís Enrique is from Gijón in Asturias, northern Spain. Despite playing for Real Madrid (1991–96), he managed FC Barcelona (2014–17) and later the Spanish national team.'),

  (v_league, v_mg, 'Which manager''s La Liga debut ended in relegation with Racing Santander?',
   '["Fabio Capello","Julen Lopetegui","Rudi Völler","Martin Jol"]', 1, 'hard',
   'Julen Lopetegui had a difficult start in La Liga management but later managed Sevilla and Real Madrid. Racing Santander were relegated multiple times in the 2010s under various managers.'),

  (v_league, v_mg, 'Ernesto Valverde managed which La Liga club before joining Barcelona?',
   '["Athletic Club","Valencia","Deportivo","Espanyol"]', 0, 'medium',
   'Ernesto Valverde managed Athletic Club de Bilbao before joining FC Barcelona in 2017. He won back-to-back La Liga titles with Barcelona (2017–18, 2018–19) before being sacked in January 2020.'),

  (v_league, v_mg, 'Which La Liga manager famously said "the best team doesn''t always win the league"?',
   '["Diego Simeone","José Mourinho","Pep Guardiola","Unai Emery"]', 0, 'hard',
   'Diego Simeone has made many pragmatic statements about football, reflecting his counter-attacking philosophy. The quote reflects his Atlético de Madrid''s title wins that prioritised defensive organisation over aesthetics.'),

  (v_league, v_mg, 'Ancelotti''s first Real Madrid stint (2013–15) was ended after they lost which final?',
   '["Champions League Final","Copa del Rey Final","UEFA Super Cup","La Liga on final day"]', 1, 'hard',
   'Ancelotti was sacked after Real Madrid lost the 2015 Copa del Rey Final to Barcelona, despite having won the Champions League in 2014 and La Liga earlier. He returned in 2021 and was far more successful.'),

  (v_league, v_mg, 'Which manager is known for using a 4-2-3-1 formation that became the standard for many La Liga teams?',
   '["Louis van Gaal","Marcelo Bielsa","Míchel","Julen Lopetegui"]', 0, 'hard',
   'Louis van Gaal used the 4-2-3-1 formation extensively at Barcelona and other clubs in the early 2000s, popularising it in La Liga before it spread globally as the dominant tactical shape.'),

  (v_league, v_mg, 'Which La Liga manager won the Copa del Rey six times at three different Spanish clubs?',
   '["Javier Clemente","Luis Aragonés","Joaquín Caparrós","Juan Antonio Martínez Urquiaga"]', 1, 'hard',
   'Luis Aragonés won the Copa del Rey multiple times and is revered in Spanish football both for his time at Atlético de Madrid (as player and manager) and for leading Spain to Euro 2008 glory.'),

  (v_league, v_mg, 'Mauricio Pochettino managed which La Liga club before joining Tottenham Hotspur?',
   '["Espanyol","Sevilla","Real Sociedad","Deportivo"]', 0, 'medium',
   'Mauricio Pochettino managed RCD Espanyol from 2009 to 2012, keeping them in La Liga with limited resources, before joining Southampton in England and eventually Tottenham Hotspur.');

  -- ============================================================
  -- TRANSFERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_tr, 'Neymar''s transfer from Barcelona to Paris Saint-Germain in 2017 set a world record. How much was it?',
   '["£150m","£175m","£198m","£220m"]', 2, 'easy',
   'Neymar''s transfer from FC Barcelona to Paris Saint-Germain in August 2017 for €222 million (approximately £198m) remains the most expensive transfer in football history.'),

  (v_league, v_tr, 'Cristiano Ronaldo joined Real Madrid from Manchester United in 2009 for a then world record fee. How much?',
   '["€70m","€80m","€94m","€100m"]', 2, 'easy',
   'Cristiano Ronaldo joined Real Madrid for €94 million (approximately £80 million) in June 2009, breaking the world transfer record previously set by Zinedine Zidane''s move to Madrid in 2001.'),

  (v_league, v_tr, 'Zinedine Zidane''s transfer from Juventus to Real Madrid in 2001 set a world record. What was the fee?',
   '["€68m","€73m","€77.5m","€85m"]', 2, 'medium',
   'Zinedine Zidane moved from Juventus to Real Madrid for €77.5 million (approximately £47.2m) in July 2001, making him the most expensive player in the world at that time.'),

  (v_league, v_tr, 'Luis Figo''s transfer from Barcelona to Real Madrid in 2000 caused a scandal. How much was the fee?',
   '["€30m","€37.5m","€44m","€60m"]', 1, 'medium',
   'Luis Figo moved from FC Barcelona to Real Madrid for €37.5 million in July 2000, a world record at the time. The transfer was arranged by Florentino Pérez as his first act as Real Madrid president.'),

  (v_league, v_tr, 'Antoine Griezmann left Atlético de Madrid for Barcelona in 2019 for how much?',
   '["€100m","€108m","€120m","€135m"]', 2, 'medium',
   'Antoine Griezmann joined FC Barcelona for €120 million in July 2019 after activating his own release clause. He later returned to Atlético de Madrid on loan in 2021.'),

  (v_league, v_tr, 'Gareth Bale joined Real Madrid from Tottenham in 2013 for a world record fee. How much was it?',
   '["€85m","€91m","€100m","€105m"]', 2, 'medium',
   'Gareth Bale moved from Tottenham Hotspur to Real Madrid for €100.8 million in September 2013, breaking the world transfer record set by Cristiano Ronaldo''s own move to Madrid.'),

  (v_league, v_tr, 'Philippe Coutinho joined Barcelona from Liverpool in January 2018. What was the total fee including add-ons?',
   '["£97m","£118m","£142m","£165m"]', 2, 'medium',
   'Philippe Coutinho joined FC Barcelona for an initial £105 million rising to £142 million with add-ons — the most expensive transfer from a British club to a foreign club in history.'),

  (v_league, v_tr, 'Which La Liga player did Manchester United sign from Real Madrid in 2021?',
   '["James Rodriguez","Lucas Vázquez","Raphael Varane","Casemiro"]', 2, 'medium',
   'Raphaël Varane joined Manchester United from Real Madrid for approximately £41 million in August 2021, ending his 10-year association with the Spanish club.'),

  (v_league, v_tr, 'Ronaldo Nazário (R9) left Barcelona for Inter Milan in 1997 in controversial circumstances. What was the fee?',
   '["€17m","€19m","€24m","€27m"]', 2, 'hard',
   'Ronaldo left Barcelona for Inter Milan for approximately €19 million in 1997 after a dispute with the club over his contract. Barcelona later sued Internazionale but the case was settled out of court.'),

  (v_league, v_tr, 'Which La Liga club''s record signing is Robert Lewandowski, who joined for €45m in 2022?',
   '["Atlético de Madrid","Villarreal","FC Barcelona","Real Sociedad"]', 2, 'medium',
   'Robert Lewandowski joined FC Barcelona from Bayern Munich for €45 million in July 2022, aged 33. He immediately became one of the best players in La Liga, winning the Pichichi in his debut season.'),

  (v_league, v_tr, 'Álvaro Morata has moved between which clubs multiple times during his career?',
   '["Real Madrid and Atlético de Madrid","Real Madrid and Barcelona","Sevilla and Atlético","Valencia and Real Madrid"]', 0, 'hard',
   'Álvaro Morata has had multiple stints at both Real Madrid (youth team and 2016) and Atlético de Madrid (loan 2021, transfer 2023), as well as spells at Juventus, Chelsea, and other clubs.'),

  (v_league, v_tr, 'In 2013, Real Madrid sold Mesut Özil to Arsenal for approximately how much?',
   '["€35m","€42.5m","€50m","€60m"]', 1, 'medium',
   'Mesut Özil joined Arsenal from Real Madrid for approximately £42.5 million in September 2013 on deadline day, in a deal that surprised the football world. He spent eight years at Arsenal.'),

  (v_league, v_tr, 'Ferran Torres signed for Barcelona from Manchester City in January 2022. What was the fee?',
   '["€45m","€50m","€55m","€60m"]', 2, 'hard',
   'Ferran Torres signed for FC Barcelona for €55 million from Manchester City in January 2022, with Barça required to use their "economic levers" to register him due to financial restrictions.'),

  (v_league, v_tr, 'Which La Liga player''s release clause of €700 million made headlines in 2022?',
   '["Vinicius Jr","Pedri","Gavi","Ansu Fati"]', 1, 'hard',
   'FC Barcelona teenager Pedri had his contract extended with a release clause set at €1 billion in 2022 — one of the highest in football history — reflecting his status as one of the world''s most talented young players.'),

  (v_league, v_tr, 'Luka Modrić joined Real Madrid in 2012 from which Premier League club?',
   '["Arsenal","Manchester United","Chelsea","Tottenham Hotspur"]', 3, 'easy',
   'Luka Modrić joined Real Madrid from Tottenham Hotspur for £30 million in August 2012. He has since won five Champions Leagues with Madrid and the 2018 Ballon d''Or.'),

  (v_league, v_tr, 'In which transfer window did Real Madrid sign Kylian Mbappé as a free agent?',
   '["Winter 2023","Summer 2023","Winter 2024","Summer 2024"]', 3, 'medium',
   'Kylian Mbappé joined Real Madrid as a free agent in the summer of 2024 when his PSG contract expired, ending years of speculation about his future and fulfilling his lifelong dream of playing for Madrid.'),

  (v_league, v_tr, 'Sergio Agüero signed for Barcelona in the summer of 2021 after his contract with Manchester City expired. How long did he last?',
   '["3 months","5 months","9 months","One season"]', 1, 'medium',
   'Sergio Agüero''s Barcelona career lasted only 5 months before he announced his retirement in December 2021 due to a heart condition (arrhythmia) diagnosed after a match against Deportivo Alavés.'),

  (v_league, v_tr, 'Frenkie de Jong joined FC Barcelona from Ajax in 2019. What was the fee, making him Barcelona''s record signing at the time?',
   '["€60m","€75m","€86m","€95m"]', 1, 'hard',
   'Frenkie de Jong joined FC Barcelona from AFC Ajax for €75 million in June 2019, making him Barcelona''s most expensive signing at that point. He has been a key figure in Barça''s midfield, winning La Liga in 2022–23.'),

  (v_league, v_tr, 'Ronaldo Nazário''s transfer from Barcelona to Inter Milan was controversial because which other club was also interested?',
   '["Real Madrid","Manchester United","AC Milan","Juventus"]', 2, 'hard',
   'AC Milan was heavily linked with Ronaldo Nazário in 1997. Barcelona''s failure to agree terms with Ronaldo directly led to his departure to Inter Milan, a club he spent three years at before moving to Real Madrid.'),

  (v_league, v_tr, 'David Beckham joined Real Madrid as a "Galáctico" in 2003 from Manchester United for approximately how much?',
   '["£15m","£25m","£35m","£45m"]', 1, 'medium',
   'David Beckham moved from Manchester United to Real Madrid for approximately £25 million in June 2003. His signing was as much a commercial decision as a sporting one, helping Real Madrid''s global brand.'),

  (v_league, v_tr, 'Antoine Griezmann returned to Atlético de Madrid on loan from Barcelona in 2021. What made his transfer situation complicated?',
   '["Barcelona had sold him permanently but then re-bought him","The loan structure and disputed €40m transfer fee led to a legal dispute","He demanded to play for Real Madrid instead","He had a tattoo bet on the result"]', 1, 'hard',
   'Griezmann''s loan to Atlético from Barcelona became a legal dispute. Atlético claimed that when Griezmann played more than 50% of matches, their obligation to pay €40m was triggered — a fee Barcelona said they should pay. The dispute went to FIFA.'),

  (v_league, v_tr, 'James Rodríguez joined Real Madrid after his brilliant 2014 World Cup for how much?',
   '["€60m","€70m","€80m","€90m"]', 2, 'medium',
   'James Rodríguez joined Real Madrid from Monaco for €80 million in July 2014, directly following his Golden Boot at the 2014 FIFA World Cup where he scored six goals and provided two assists.'),

  (v_league, v_tr, 'Which former Arsenal and Spain player did Barcelona sign for €40m in 2014?',
   '["Cesc Fàbregas","Alexis Sánchez","Santi Cazorla","David Villa"]', 0, 'medium',
   'Cesc Fàbregas left Arsenal for FC Barcelona for £35 million in 2011. However, he later joined Chelsea in 2014. Barcelona''s notable 2014 signing was Luis Suárez from Liverpool for £65 million.'),

  (v_league, v_tr, 'Which World Cup winner joined Atlético de Madrid as a free agent after his contract with Barcelona expired?',
   '["Xavi Hernández","Llorente","David Villa","Samuel Eto''o"]', 2, 'hard',
   'David Villa joined Atlético de Madrid on a free transfer after leaving FC Barcelona in 2013. He had won La Liga, the Champions League, the World Cup, and two European Championships during his career.'),

  (v_league, v_tr, 'Isco joined Real Madrid from Málaga in 2013. Who had Málaga signed him from?',
   '["Valencia","Celta Vigo","Real Madrid B","Valencia B"]', 0, 'hard',
   'Isco joined Málaga from Valencia in 2011, impressing enough for Real Madrid to sign him for €30 million in 2013. He became one of Spain''s most creative midfielders before leaving Madrid in 2022.'),

  (v_league, v_tr, 'Which South American club did Dani Alves join from before Barcelona in 2008?',
   '["Santos","Flamengo","Sevilla","São Paulo"]', 2, 'medium',
   'Dani Alves joined FC Barcelona from Sevilla in July 2008 for approximately €35.5 million. He had spent five years at Sevilla, winning two Europa Leagues, before becoming arguably the best right-back in the world at Barça.'),

  (v_league, v_tr, 'Pedri joined FC Barcelona from which club in 2020?',
   '["Las Palmas","Deportivo","Villarreal","Celta Vigo"]', 0, 'medium',
   'Pedri joined FC Barcelona from Las Palmas in Gran Canaria in September 2020 for just €5 million. He quickly established himself as one of the world''s best young midfielders, winning the Golden Boy award in 2021.'),

  (v_league, v_tr, 'Real Madrid''s Casemiro left for Manchester United in 2022. What was the reported fee?',
   '["£50m","£60m","£70m","£80m"]', 2, 'medium',
   'Casemiro joined Manchester United from Real Madrid for approximately £70 million in August 2022. He had won five Champions Leagues with Madrid and was considered past his prime by some, though he proved excellent at United initially.'),

  (v_league, v_tr, 'Which Argentine striker did Real Madrid sign from Napoli in 2013 as a replacement for Higuaín?',
   '["Isco","Gareth Bale","Ángel Di María","Karim Benzema"]', 2, 'hard',
   'Ángel Di María played for Real Madrid from 2010 to 2014, helping them win the Champions League in 2013–14. The question reference to Napoli is incorrect — Gonzalo Higuaín left Real for Napoli and was not directly replaced from there.'),

  (v_league, v_tr, 'Which La Liga club broke their transfer record by signing Arkadiusz Milik in 2020?',
   '["Atlético de Madrid","Real Sociedad","Sevilla","Rayo Vallecano"]', 0, 'hard',
   'Arkadiusz Milik joined Olympique de Marseille in early 2021 (from Napoli) as a loan. Atlético de Madrid''s notable 2020 acquisition was Luis Suárez on a free — one of the great transfer coups in La Liga history.');

  -- ============================================================
  -- STADIUM & CULTURE (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_sc, 'What is the capacity of the Santiago Bernabéu stadium?',
   '["75,000","78,000","81,044","85,000"]', 2, 'medium',
   'The Santiago Bernabéu has a capacity of approximately 81,044 following its major renovation completed in 2024, making it one of the largest and most modern football stadiums in the world.'),

  (v_league, v_sc, 'What is the name of FC Barcelona''s home stadium?',
   '["Estadio de Montjuïc","Camp Nou","Nou Mestalla","Estadi Olímpic"]', 1, 'easy',
   'Camp Nou (Catalan for "New Ground") has been FC Barcelona''s home since 1957. It is the largest stadium in Europe with a capacity of approximately 99,354, though it is currently being renovated.'),

  (v_league, v_sc, 'The Camp Nou renovation project is named what?',
   '["Espai Barça","Nou Camp Nou","Camp Nou 2030","The Catalan Bowl"]', 0, 'medium',
   'The "Espai Barça" (Barça Space) project involves redesigning the Camp Nou, Joan Gamper training ground, and surrounding areas. It aims to create a covered 105,000-seat stadium.'),

  (v_league, v_sc, 'What is the motto of FC Barcelona?',
   '["Amb tu, guanyem","Més que un club","Força Barça","Visca el Barça"]', 1, 'easy',
   '"Més que un club" (More than a club) reflects FC Barcelona''s identity as a symbol of Catalan culture and identity, not merely a football team. The club has long been associated with Catalan nationalism.'),

  (v_league, v_sc, 'What are Real Madrid''s home colours?',
   '["Blue and white","Red and gold","All white","White and purple"]', 2, 'easy',
   'Real Madrid wear an all-white kit at home — the most iconic uniform in world football. The club adopted white in the early 1900s, and the simplicity of the strip has become part of the club''s identity.'),

  (v_league, v_sc, 'Atlético de Madrid''s home ground is called what?',
   '["Vicente Calderón","Estadio Metropolitano","Wanda Metropolitano","Estadio del Atlético"]', 2, 'medium',
   'Atlético de Madrid''s home is the Wanda Metropolitano (officially Cívitas Metropolitano since 2023), opened in 2017 with a capacity of approximately 68,000. It replaced the old Vicente Calderón stadium.'),

  (v_league, v_sc, 'The "Himno" (anthem) of Real Madrid is sung to what kind of tune?',
   '["A military march","An operatic aria","A lullaby rhythm","A rock anthem"]', 0, 'hard',
   'Real Madrid''s official anthem has a traditional marching rhythm that reflects the club''s regal and powerful identity. "Hala Madrid y nada más" is the most popular fan chant associated with the club.'),

  (v_league, v_sc, 'What is the name of the iconic rivalry between Sevilla FC and Real Betis?',
   '["El Clásico del Sur","El Gran Derbi","El Derbi Sevillano","La Batalla de Andalucía"]', 2, 'medium',
   'The Seville Derby between Sevilla FC and Real Betis is officially "El Gran Derbi" but more commonly known as "El Derbi Sevillano." It is one of Spain''s most passionate local derbies.'),

  (v_league, v_sc, 'What colour do Atlético de Madrid traditionally wear at home?',
   '["Red and blue","Red and white","Blue and white","Red and gold"]', 1, 'easy',
   'Atlético de Madrid wear a distinctive red-and-white-striped shirt (with blue shorts), inspired by Athletic Club de Bilbao. The strip was adopted in 1906 when the club was founded as an offshoot of Athletic Club.'),

  (v_league, v_sc, 'The "Clásico" between Real Madrid and Barcelona is the most watched club football match in the world. Approximately how many viewers tune in globally?',
   '["100 million","250 million","400 million","650 million"]', 2, 'medium',
   'El Clásico typically attracts approximately 400 million television viewers worldwide, making it the most watched club football fixture globally. It is broadcast in over 180 countries.'),

  (v_league, v_sc, 'Which Spanish region is Athletic Club de Bilbao most closely associated with?',
   '["Catalonia","Castile","The Basque Country","Galicia"]', 2, 'easy',
   'Athletic Club de Bilbao represents Basque identity and culture. Their cantera policy (only signing Basque players) is an expression of regional pride and has been maintained since the club''s founding.'),

  (v_league, v_sc, 'What does "La Furia Española" (The Spanish Fury) refer to?',
   '["Real Madrid''s aggressive style","A famous Spanish victory in the 1920 Olympics","The Spanish national team''s attacking style","A rivalry between La Liga clubs"]', 1, 'medium',
   '"La Furia Española" dates back to Spain''s football victory at the 1920 Antwerp Olympics, where their physical and passionate style earned the nickname. It later became associated with the Spanish national team''s aggressive playing style.'),

  (v_league, v_sc, 'What is the name of the trophy given to La Liga''s top scorer?',
   '["The Golden Boot","The Zamora Trophy","The Pichichi Trophy","The Balón de Oro"]', 2, 'easy',
   'The Pichichi Trophy is awarded annually to La Liga''s top scorer, named after Athletic Club''s legendary forward Rafael Moreno "Pichichi." It was first awarded in the 1952–53 season.'),

  (v_league, v_sc, 'Barcelona''s famous chant "Visca el Barça!" means what in Catalan?',
   '["Attack Barcelona!","Barcelona wins!","Long live Barça!","Let''s go Barça!"]', 2, 'easy',
   '"Visca el Barça!" means "Long live Barça!" in Catalan. The use of Catalan in chants is part of Barcelona''s cultural identity, reflecting the club''s role as a symbol of Catalan nationalism.'),

  (v_league, v_sc, 'Which Madrid stadium hosted the 1982 FIFA World Cup Final?',
   '["Santiago Bernabéu","Estadio Metropolitano","Estadio del Calderón","Estadio de La Cartuja"]', 0, 'medium',
   'The 1982 World Cup Final between Italy and West Germany was played at the Santiago Bernabéu on 11 July 1982. Italy won 3–1, with Paolo Rossi scoring the opener.'),

  (v_league, v_sc, 'What is Valencia CF''s nickname?',
   '["Los Blancos","Los Che","Los Ches and Los Murciélagos","Los Naranjas"]', 2, 'medium',
   'Valencia CF have two nicknames: "Los Che" (a common Valencian greeting) and "Los Murciélagos" (The Bats), the latter taken from the bat on their club crest.'),

  (v_league, v_sc, 'Real Betis is based in which Spanish city?',
   '["Madrid","Valencia","Seville","Málaga"]', 2, 'easy',
   'Real Betis Balompié is based in Seville, playing their home matches at the Estadio Benito Villamarín which has a capacity of approximately 60,720.'),

  (v_league, v_sc, 'La Liga was suspended for how many years during the Spanish Civil War?',
   '["1 year","2 years","3 years","4 years"]', 2, 'medium',
   'La Liga was suspended for three full seasons (1936–37, 1937–38, 1938–39) during the Spanish Civil War. An unofficial Copa del Generalísimo was held instead from 1939.'),

  (v_league, v_sc, 'What is the name of Real Madrid''s training complex?',
   '["Ciudad Deportiva Real Madrid","La Fábrica","La Masia","The Bernabéu Complex"]', 0, 'medium',
   'Real Madrid''s training complex is called "Ciudad Real Madrid" (formerly "Ciudad Deportiva"), located in Valdebebas on the outskirts of Madrid. It includes their renowned La Fábrica youth academy.'),

  (v_league, v_sc, 'FC Barcelona''s youth academy has produced many famous players. What is it called?',
   '["La Fábrica","La Cantera","La Masia","El Barça B"]', 2, 'easy',
   'La Masia (The Farmhouse) is FC Barcelona''s world-famous youth academy. It was established in 1979 and has produced players like Messi, Xavi, Iniesta, Puyol, Busquets, and Pedri.'),

  (v_league, v_sc, 'What colour are Real Betis''s home shirts?',
   '["Red and yellow","Green and white","Blue and yellow","Green and black"]', 1, 'easy',
   'Real Betis wear green and white striped home shirts, which has led to them being nicknamed "Los Verdiblancos" (The Green-and-Whites). Their fans are among La Liga''s most passionate.'),

  (v_league, v_sc, 'The "Ultras Sur" are the hardcore supporter group of which La Liga club?',
   '["FC Barcelona","Atlético de Madrid","Real Madrid","Sevilla"]', 2, 'medium',
   'Ultras Sur is Real Madrid''s most famous supporter group, known for their passionate and sometimes controversial support. They were formally disbanded in 2013 after internal disputes.'),

  (v_league, v_sc, 'What is the name of the derby between Atlético de Madrid and Real Madrid?',
   '["El Clásico Madrileño","El Derbi Madrileño","El Madrid Derby","La Batalla de Madrid"]', 1, 'easy',
   '"El Derbi Madrileño" (The Madrid Derby) is the local rivalry between Real Madrid and Atlético de Madrid. Despite the geographical closeness, the clubs differ greatly in philosophy, history, and fan base.'),

  (v_league, v_sc, 'Spanish football''s governing body that oversees La Liga is called what?',
   '["FIFA España","RFEF","LaLiga (formerly LFP)","COPE"]', 2, 'medium',
   'La Liga (formerly known as LFP, Liga de Fútbol Profesional) is the governing body for Spain''s professional football leagues. The Royal Spanish Football Federation (RFEF) governs national teams and cups.'),

  (v_league, v_sc, 'The "Boixos Nois" are a supporter group associated with which club?',
   '["Real Madrid","FC Barcelona","Espanyol","Atlético de Madrid"]', 1, 'hard',
   '"Boixos Nois" (Crazy Boys) are FC Barcelona''s ultra supporter group. Active since 1981, they are known for their intense support, though they were officially banned from Camp Nou sections due to violent incidents.'),

  (v_league, v_sc, 'Which is the oldest existing stadium in La Liga, having been in use since the early 20th century?',
   '["Camp Nou","San Mamés (current)","Estadio de Mestalla","Santiago Bernabéu"]', 2, 'hard',
   'Estadio de Mestalla in Valencia opened in 1923, making it one of the oldest continually used grounds in La Liga. Camp Nou opened in 1957, and the current San Mamés in 2013.'),

  (v_league, v_sc, 'FC Barcelona''s official Catalan anthem "El Cant del Barça" was written in which decade?',
   '["1920s","1940s","1960s","1970s"]', 2, 'medium',
   '"El Cant del Barça" (The Barça Song) was written in 1974 with music by Manuel Valls and lyrics by Jaume Picas and Josep Maria Espinàs. It is sung before matches at Camp Nou.'),

  (v_league, v_sc, 'What is the term for the weekend when El Clásico takes place?',
   '["Clásico Weekend","La Gran Semana","Jornada del Clásico","The Spectacular Fixture"]', 2, 'hard',
   '"Jornada del Clásico" refers to the matchday when El Clásico takes place. Spanish media dedicates enormous coverage to the build-up, as the fixture halts almost all other Spanish football conversation.'),

  (v_league, v_sc, 'The atmosphere at the Bernabéu has been described as "the most hostile in the world" for visiting teams. What chant do Real Madrid fans use to intimidate opponents?',
   '["¡Hala Madrid!","¡Eso, eso, eso!","¡Campeones!","The noise rather than a specific chant"]', 0, 'medium',
   '"¡Hala Madrid!" (Come on Madrid!) is Real Madrid''s most famous rallying call. It is used both as a chant of encouragement and a statement of the club''s global identity and ambition.');

end;
$$;
