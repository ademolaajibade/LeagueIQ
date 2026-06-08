-- ============================================================
-- LeagueIQ — Seed: Bundesliga Questions (210)
-- 30 per category × 7 categories
-- ============================================================

do $$
declare
  v_league  uuid := '44444444-4444-4444-4444-444444444444';
  v_ch      uuid; -- club_history
  v_fp      uuid; -- famous_players
  v_dk      uuid; -- der_klassiker
  v_rs      uuid; -- records_stats
  v_mg      uuid; -- managers
  v_tr      uuid; -- transfers
  v_sc      uuid; -- stadium_culture
begin
  select id into v_ch from public.categories where league_id = v_league and slug = 'club_history';
  select id into v_fp from public.categories where league_id = v_league and slug = 'famous_players';
  select id into v_dk from public.categories where league_id = v_league and slug = 'der_klassiker';
  select id into v_rs from public.categories where league_id = v_league and slug = 'records_stats';
  select id into v_mg from public.categories where league_id = v_league and slug = 'managers';
  select id into v_tr from public.categories where league_id = v_league and slug = 'transfers';
  select id into v_sc from public.categories where league_id = v_league and slug = 'stadium_culture';

  -- ============================================================
  -- CLUB HISTORY (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_ch, 'How many Bundesliga titles has Bayern Munich won in total?',
   '["28","30","33","36"]', 2, 'easy',
   'Bayern Munich have won the Bundesliga 33 times as of the 2023–24 season — by far the most of any German club. They won 11 consecutive titles from 2012–13 to 2022–23.'),

  (v_league, v_ch, 'In what year was the Bundesliga founded?',
   '["1955","1959","1963","1968"]', 2, 'easy',
   'The Bundesliga was founded in 1963, the same year that German football emerged from the regional league system. Bayern Munich were not in the inaugural season — they were promoted later.'),

  (v_league, v_ch, 'Which club was in the inaugural Bundesliga season in 1963–64 and has remained ever since?',
   '["Bayern Munich","Borussia Dortmund","Werder Bremen","Hamburger SV"]', 3, 'hard',
   'Hamburger SV was the only club to have played in every Bundesliga season since 1963 — until they were relegated in 2018, ending a 55-year unbroken top-flight run.'),

  (v_league, v_ch, 'Borussia Dortmund was founded in which year?',
   '["1903","1909","1913","1919"]', 1, 'medium',
   'Borussia Dortmund was founded on 19 December 1909 by a group of young workers from a Catholic youth club. The name "Borussia" is a Latin word for "Prussia."'),

  (v_league, v_ch, 'Borussia Dortmund won their only Champions League title in 1997. Which club did they beat in the final and what was the score?',
   '["AC Milan 2–1","Juventus 3–1","Real Madrid 2–0","Barcelona 1–0"]', 1, 'hard',
   'Borussia Dortmund beat Juventus 3–1 in the 1997 Champions League Final in Munich, with Karl-Heinz Riedle scoring twice and Lars Ricken lobbing Peruzzi with his first touch after coming on as a substitute. It remains BVB''s only European Cup triumph.'),

  (v_league, v_ch, 'Bayern Munich won the Bundesliga for how many consecutive seasons from 2012–13 to 2022–23?',
   '["8","9","10","11"]', 3, 'easy',
   'Bayern Munich won 11 consecutive Bundesliga titles from 2012–13 to 2022–23 — the longest consecutive title run by any club in a major European top-flight league.'),

  (v_league, v_ch, 'Bayer Leverkusen is nicknamed "Neverkusen" for which reason?',
   '["They never win away games","They have never won a Bundesliga title — until 2023–24","They never score goals","They never keep clean sheets"]', 1, 'medium',
   'Bayer Leverkusen were called "Neverkusen" for their habit of finishing second — in the Bundesliga, the DFB-Pokal, and the UEFA Cup all in 2001–02. They finally won the Bundesliga for the first time in 2023–24 under Xabi Alonso.'),

  (v_league, v_ch, 'Which German club is owned by a pharmaceutical company (Bayer AG)?',
   '["Hoffenheim","RB Leipzig","Bayer Leverkusen","Wolfsburg"]', 2, 'easy',
   'Bayer Leverkusen is owned by Bayer AG, the pharmaceutical and chemical giant. The club was founded in 1904 as a sports club for Bayer employees — hence the unusual corporate ownership in German football.'),

  (v_league, v_ch, 'RB Leipzig is controversial in Germany for which reason?',
   '["They signed too many foreign players","Their ownership structure circumvents the 50+1 rule","They were founded in East Germany","They have no youth academy"]', 1, 'medium',
   'RB Leipzig is backed by Red Bull and many German fans consider them a "plastic club" that circumvents the 50+1 ownership rule (fans must own majority voting rights). They were founded only in 2009.'),

  (v_league, v_ch, 'Werder Bremen has won the Bundesliga how many times?',
   '["3","4","5","6"]', 1, 'medium',
   'Werder Bremen have won the Bundesliga four times (1964–65, 1987–88, 1992–93, 2003–04) and are one of the historically successful German clubs, though they have declined significantly in recent years.'),

  (v_league, v_ch, 'Borussia Mönchengladbach was a dominant force in German and European football during which decade?',
   '["1960s","1970s","1980s","1990s"]', 1, 'medium',
   'Borussia Mönchengladbach dominated German football in the 1970s, winning five Bundesliga titles in nine years and two UEFA Cup trophies. They were known as the "Fohlen-Elf" (Foals XI).'),

  (v_league, v_ch, 'Which club won the first ever Bundesliga title in 1963–64?',
   '["Bayern Munich","1. FC Cologne","Borussia Dortmund","Schalke 04"]', 1, 'hard',
   '1. FC Cologne won the inaugural Bundesliga season in 1963–64. Bayern Munich were not even in the Bundesliga until 1965 — they were promoted from the Regionalliga Bayern.'),

  (v_league, v_ch, 'Bayern Munich was founded in which year?',
   '["1896","1900","1900","1910"]', 1, 'easy',
   'FC Bayern Munich was founded on 27 February 1900 by 11 members of a gymnastics club in Munich. They are now the most valuable football club in Germany.'),

  (v_league, v_ch, 'What is the full name of the club commonly known as Schalke?',
   '["FC Gelsenkirchen","FC Schalke 04","Gelsenkirchen FC 1904","Royal Blau-Weiß"]', 1, 'easy',
   'FC Schalke 04 was founded on 4 May 1904 (hence the "04") in the Schalke district of Gelsenkirchen in the Ruhr industrial region. Their coal-mining community roots make them one of Germany''s most iconic working-class clubs.'),

  (v_league, v_ch, 'Which Bundesliga club plays at the Veltins-Arena?',
   '["Borussia Dortmund","Bayern Munich","Schalke 04","Bayer Leverkusen"]', 2, 'medium',
   'Schalke 04 plays their home matches at the Veltins-Arena in Gelsenkirchen, capacity approximately 62,271. It is named after Veltins Brewery and is known for its retractable roof.'),

  (v_league, v_ch, 'Hamburger SV was relegated from the Bundesliga for the first time in which year?',
   '["2015","2016","2018","2019"]', 2, 'medium',
   'Hamburger SV was relegated from the Bundesliga in 2018, ending their 55-year unbroken top-flight run — the longest in any major European league. The club has since struggled to return to the top flight.'),

  (v_league, v_ch, 'Which club was founded as a result of a merger of two Dortmund clubs in 1909?',
   '["Schalke 04","Bayer Leverkusen","Borussia Dortmund","Fortuna Düsseldorf"]', 2, 'hard',
   'Borussia Dortmund was founded in December 1909, but not through a merger. The club emerged from a break with the Catholic Trinity youth club. The name "Borussia" was chosen to reflect the Latin name for Prussia.'),

  (v_league, v_ch, 'VfB Stuttgart won the Bundesliga most recently in which season?',
   '["2003–04","2005–06","2006–07","2009–10"]', 2, 'medium',
   'VfB Stuttgart won the Bundesliga in 2006–07 under Armin Veh, with Mario Gomez as their leading scorer. It was their fifth German championship and their most recent title.'),

  (v_league, v_ch, 'Which Bundesliga club is wholly owned by the Volkswagen automobile company?',
   '["Wolfsburg","Augsburg","Ingolstadt","Bochum"]', 0, 'easy',
   'VfL Wolfsburg is owned by Volkswagen AG and was founded in 1945 for Volkswagen factory workers. The club won their only Bundesliga title in 2008–09 with Edin Džeko and Grafite scoring 54 goals combined.'),

  (v_league, v_ch, 'Borussia Dortmund won the Bundesliga title in 2010–11 and 2011–12. Who was their manager?',
   '["Jürgen Klopp","Thomas Tuchel","Ottmar Hitzfeld","Lucien Favre"]', 0, 'easy',
   'Jürgen Klopp managed Borussia Dortmund from 2008 to 2015, winning back-to-back Bundesliga titles (2010–11 and 2011–12) with a high-energy pressing style he called "Gegenpressing."'),

  (v_league, v_ch, 'Bayern Munich''s most successful period in European football was in the early 1970s. How many consecutive European Cups did they win?',
   '["2","3","4","5"]', 1, 'medium',
   'Bayern Munich won three consecutive European Cups from 1974 to 1976, with Franz Beckenbauer as captain and players like Gerd Müller and Sepp Maier in their legendary squad.'),

  (v_league, v_ch, 'Which Bundesliga club is nicknamed "Die Schwarzgelben" (The Black and Yellows)?',
   '["SC Freiburg","Borussia Dortmund","Schalke 04","Bayer Leverkusen"]', 1, 'easy',
   'Borussia Dortmund are nicknamed "Die Schwarzgelben" (The Black and Yellows) and "BVB" for their distinctive black and yellow kit. The colours were adopted in 1913.'),

  (v_league, v_ch, 'The 50+1 rule in German football means what?',
   '["Clubs must field 50% domestic players","Fans/members must own more than 50% of voting shares","Teams must keep 50% of their transfer fees","Youth players over 50% of the squad"]', 1, 'medium',
   'The 50+1 rule requires that a club''s registered members control more than 50% of voting rights, preventing pure corporate takeovers. This protects German fan culture but limits the ability to attract external investment.'),

  (v_league, v_ch, 'Which city has the Bundesliga rivalry called the "Revierderby"?',
   '["Munich","Hamburg","Ruhr region (Dortmund vs Schalke)","Berlin"]', 2, 'medium',
   'The Revierderby between Borussia Dortmund and Schalke 04 is one of Germany''s most heated rivalries, contested in the Ruhr industrial heartland (Revier). The two clubs are based only 30km apart.'),

  (v_league, v_ch, 'Which German club has won the DFB-Pokal (German Cup) the most times?',
   '["Schalke 04","Borussia Dortmund","Werder Bremen","Bayern Munich"]', 3, 'medium',
   'Bayern Munich have won the DFB-Pokal 20 times — more than any other German club. They are the dominant force in both domestic cup and league football in Germany.'),

  (v_league, v_ch, 'Eintracht Frankfurt won the UEFA Europa League in which year?',
   '["2018","2019","2021","2022"]', 3, 'medium',
   'Eintracht Frankfurt won the UEFA Europa League in 2021–22, defeating Rangers on penalties in the final in Seville. The match was remarkable for the 100,000+ Frankfurt fans who travelled to Spain.'),

  (v_league, v_ch, 'Which Bundesliga club achieved their greatest moment by winning the UEFA Cup in 1996?',
   '["Schalke 04","Borussia Mönchengladbach","Hamburger SV","Werder Bremen"]', 0, 'hard',
   'Schalke 04 won the UEFA Cup in 1996, defeating AC Milan on penalties in the final. It remains Schalke''s greatest European achievement and one of the most celebrated days in the club''s history.'),

  (v_league, v_ch, 'Bayer Leverkusen finally won the Bundesliga for the first time in 2023–24 without losing a match all season. Who was their manager?',
   '["Andi Brehme","Uli Hoeneß","Xabi Alonso","Hansi Flick"]', 2, 'easy',
   'Xabi Alonso guided Bayer Leverkusen to an unbeaten Bundesliga season in 2023–24, ending Bayern Munich''s 11-year title run. Leverkusen also reached the Europa League Final and DFB-Pokal Final.'),

  (v_league, v_ch, 'Borussia Dortmund''s Champions League Final appearances were in which years?',
   '["1997 and 2011","1997 and 2013","2012 and 2013","2013 and 2019"]', 1, 'medium',
   'Borussia Dortmund reached two Champions League Finals — winning in 1997 (vs Juventus, 3–1) and losing in 2013 (vs Bayern Munich, 1–2 at Wembley) and again losing in 2024 (vs Real Madrid, 0–2 at Wembley).'),

  (v_league, v_ch, 'SC Freiburg is notable for its youth development. Which area of Germany are they from?',
   '["Bavaria","Saxony","Baden-Württemberg","North Rhine-Westphalia"]', 2, 'medium',
   'SC Freiburg is based in Freiburg im Breisgau in Baden-Württemberg in southwest Germany, near the French border. They are known for their sustainable development model and consistently punching above their weight in the Bundesliga.');

  -- ============================================================
  -- FAMOUS PLAYERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_fp, 'Who is the all-time top scorer in Bundesliga history?',
   '["Jupp Heynckes","Uwe Seeler","Gerd Müller","Robert Lewandowski"]', 2, 'easy',
   'Gerd Müller scored 365 Bundesliga goals for Bayern Munich between 1965 and 1979 — the all-time record. He was nicknamed "Der Bomber" for his lethal penalty area goalscoring.'),

  (v_league, v_fp, 'Franz Beckenbauer is credited with inventing which position?',
   '["The false 9","The attacking midfielder","The sweeper/libero (attacking)","The holding midfielder"]', 2, 'medium',
   'Franz Beckenbauer revolutionised the sweeper role by playing as an attacking libero, carrying the ball forward from defence. He became known as "Der Kaiser" and is considered Germany''s greatest ever player.'),

  (v_league, v_fp, 'Robert Lewandowski set the single-season Bundesliga scoring record in 2020–21. How many goals did he score?',
   '["36","41","43","44"]', 1, 'easy',
   'Robert Lewandowski scored 41 Bundesliga goals in the 2020–21 season for Bayern Munich, breaking Gerd Müller''s 49-year record of 40 goals in a single season. He also scored in 17 consecutive matches.'),

  (v_league, v_fp, 'Which Bayern Munich forward won the Ballon d''Or in 1980?',
   '["Gerd Müller","Franz Beckenbauer","Karl-Heinz Rummenigge","Sepp Maier"]', 2, 'medium',
   'Karl-Heinz Rummenigge won the Ballon d''Or in 1980 and 1981, making him the first player to win it in consecutive years since the award''s inception (after Beckenbauer himself in 1972 and 1976).'),

  (v_league, v_fp, 'Which Borussia Dortmund midfielder was nicknamed "Biene" and was central to their Champions League winning squad in 1997?',
   '["Stefan Reuter","Andreas Möller","Paulo Sousa","Matthias Sammer"]', 1, 'hard',
   'Andreas Möller was a central figure in Borussia Dortmund''s 1997 Champions League win. Matthias Sammer won the Ballon d''Or that year, but it was Möller''s creativity and penalties that drove Dortmund''s success.'),

  (v_league, v_fp, 'Which Polish striker joined Bayern Munich in 2014 from Borussia Dortmund?',
   '["Robert Lewandowski","Łukasz Piszczek","Sven Bender","Jakub Błaszczykowski"]', 0, 'easy',
   'Robert Lewandowski moved from Borussia Dortmund to Bayern Munich on a free transfer in 2014. His move was highly controversial in Dortmund, where he had scored 74 Bundesliga goals.'),

  (v_league, v_fp, 'Oliver Kahn was Germany''s greatest goalkeeper during which era?',
   '["1980s–90s","1990s–2000s","2000s–2010s","Throughout the 1970s"]', 1, 'medium',
   'Oliver Kahn was Germany''s first-choice goalkeeper through the 1990s and 2000s, winning the Golden Ball at the 2002 World Cup. He made 429 Bundesliga appearances for Bayern Munich and 86 for Germany.'),

  (v_league, v_fp, 'Which Brazilian-German player starred for Bayern Munich throughout the 2010s and won the Champions League in 2013?',
   '["Thiago Alcántara","Dante","Luiz Gustavo","Douglas Costa"]', 1, 'medium',
   'Dante (Dante Bonfim Costa Santos) played for Bayern Munich from 2012 to 2015, forming a key part of their Champions League-winning squad in 2013. He later played for other clubs in Germany and France.'),

  (v_league, v_fp, 'Matthias Sammer won the 1996 Ballon d''Or as the first German winner since Beckenbauer. Which club was he at?',
   '["Bayern Munich","Borussia Dortmund","Borussia Mönchengladbach","Schalke 04"]', 1, 'medium',
   'Matthias Sammer won the 1996 Ballon d''Or while at Borussia Dortmund, where he played as an elegant sweeper/libero. He helped Dortmund win the Champions League in 1997.'),

  (v_league, v_fp, 'Which Spanish playmaker joined Bayern Munich from Barcelona in 2013?',
   '["Dani Alves","Andrés Iniesta","Xabi Alonso","Thiago Alcántara"]', 3, 'medium',
   'Thiago Alcántara joined Bayern Munich from FC Barcelona for €25 million in 2013. He became one of Bundesliga''s most creative midfielders before joining Liverpool in 2020.'),

  (v_league, v_fp, 'Uwe Seeler is considered Hamburg''s greatest ever player. How many Bundesliga goals did he score?',
   '["136","153","188","205"]', 1, 'hard',
   'Uwe Seeler scored 137 Bundesliga goals for Hamburger SV and is considered one of Germany''s greatest strikers. He represented West Germany at four World Cups (1958–70) without ever winning the tournament.'),

  (v_league, v_fp, 'Gerd Müller set a Bundesliga single-season scoring record in 1971–72 that stood for 49 years. How many goals did he score?',
   '["34","37","40","43"]', 2, 'medium',
   'Gerd Müller scored 40 Bundesliga goals in the 1971–72 season for Bayern Munich — a record that stood until Robert Lewandowski scored 41 in 2020–21. Müller''s extraordinary strike rate earned him the nickname "Der Bomber der Nation."'),

  (v_league, v_fp, 'Mesut Özil came through Schalke 04''s academy. Which club did he join before Real Madrid signed him in 2010?',
   '["Bayer Leverkusen","Borussia Dortmund","Werder Bremen","Mainz 05"]', 2, 'medium',
   'Mesut Özil came through Schalke 04''s academy and then moved to Werder Bremen, where his performances attracted Real Madrid, who signed him for €15 million in 2010. He went on to win La Liga and become one of the most gifted passers in world football.'),

  (v_league, v_fp, 'Mesut Özil came through which Bundesliga club''s youth system?',
   '["Bayern Munich","Borussia Dortmund","Schalke 04","Bayer Leverkusen"]', 2, 'medium',
   'Mesut Özil came through Schalke 04''s youth academy before moving to Werder Bremen and then Real Madrid in 2010. His creative passing and dribbling made him one of Germany''s most gifted players.'),

  (v_league, v_fp, 'Marco Reus has been Borussia Dortmund''s captain for many years. Which major trophy was he unable to win with Dortmund?',
   '["The Champions League (reached finals but lost)","The Bundesliga","The DFB-Pokal","The Club World Cup"]', 0, 'medium',
   'Marco Reus reached the Champions League Final with BVB in 2013 but lost to Bayern Munich. Despite being a Dortmund icon for over a decade, the Champions League always eluded him.'),

  (v_league, v_fp, 'Which Borussia Dortmund striker was called "the Terminator" for his physical style?',
   '["Robert Lewandowski","Erling Haaland","Aubameyang","Sandro Wagner"]', 1, 'medium',
   'Erling Haaland joined Borussia Dortmund in January 2020 and scored 86 goals in 89 appearances — an extraordinary rate. His powerful physique earned various nicknames, and he departed for Manchester City in 2022.'),

  (v_league, v_fp, 'Thomas Müller has spent his entire career at Bayern Munich. How many Bundesliga titles has he won?',
   '["8","10","11","13"]', 2, 'hard',
   'Thomas Müller has won 11 consecutive Bundesliga titles with Bayern Munich (2012–13 to 2022–23) plus additional titles, making him one of the most decorated players in Bundesliga history.'),

  (v_league, v_fp, 'Manuel Neuer is considered by many as the best goalkeeper ever due to his "sweeper-keeper" style. Which club was he at before Bayern Munich?',
   '["Hamburger SV","Werder Bremen","Schalke 04","Borussia Dortmund"]', 2, 'easy',
   'Manuel Neuer came through Schalke 04''s academy and played for the club from 2006 to 2011 before joining Bayern Munich for approximately €25 million. His leadership of the German national team was also exceptional.'),

  (v_league, v_fp, 'Franck Ribéry and Arjen Robben formed a famous partnership at Bayern Munich. What were they collectively nicknamed?',
   '["Ribbery and Robben","The Speed Demons","Robbery","The Wide Men"]', 2, 'easy',
   '"Robbery" — a portmanteau of Ribéry and Robben — was the nickname for Bayern Munich''s devastating left-right winger combination that dominated European football from 2011 to 2019.'),

  (v_league, v_fp, 'Which Borussia Dortmund player was known for somersault celebrations in the Bundesliga?',
   '["Mario Götze","Jürgen Klopp","Pierre-Emerick Aubameyang","Kevin Großkreutz"]', 2, 'medium',
   'Pierre-Emerick Aubameyang became famous for his athletic somersault celebrations at Borussia Dortmund (2013–2018), where he scored 141 goals in 213 appearances. He won the African Player of the Year multiple times.'),

  (v_league, v_fp, 'Which German player scored the winning goal in the 2014 World Cup Final?',
   '["Thomas Müller","Mario Götze","Mesut Özil","Toni Kroos"]', 1, 'easy',
   'Mario Götze scored the winner in extra time against Argentina (1–0) in the 2014 World Cup Final in Rio de Janeiro. Joachim Löw brought Götze on specifically to make that difference — and he delivered.'),

  (v_league, v_fp, 'Lothar Matthäus is Germany''s most capped player. How many international caps did he earn?',
   '["130","144","150","152"]', 1, 'medium',
   'Lothar Matthäus won 150 international caps for West Germany/Germany — a German record. He also won the 1990 World Cup, two Bundesliga titles with Bayern, and was a truly complete midfielder.'),

  (v_league, v_fp, 'Jürgen Klinsmann was a prolific striker for Germany and Bayern Munich. What team did he notably manage?',
   '["Germany and USA","Germany only","Bayern Munich and Germany","Germany, USA, and Australia"]', 0, 'medium',
   'Jürgen Klinsmann managed the German national team (2004–06, leading them to the World Cup semi-final), USA (2011–16), and Bayern Munich (briefly 2008–09). He also briefly managed Hertha BSC.'),

  (v_league, v_fp, 'Which player is Borussia Dortmund''s all-time top scorer with 178 competitive goals for the club?',
   '["Stéphane Chapuisat","Robert Lewandowski","Alfred Preißler","Pierre-Emerick Aubameyang"]', 2, 'hard',
   'Alfred "Aki" Preißler scored 178 goals for Borussia Dortmund in competitive football — the most by any player in the club''s history. He played for BVB from 1949 to 1959, a period when Dortmund were German champions.'),

  (v_league, v_fp, 'Which Bundesliga club''s academy produced Toni Kroos, who went on to dominate Real Madrid''s midfield?',
   '["Hamburger SV","Bayer Leverkusen","Bayern Munich","Hoffenheim"]', 2, 'medium',
   'Toni Kroos came through Bayern Munich''s youth academy, played for Bayern from 2007 to 2014, and then joined Real Madrid for €25 million. He became one of the world''s best midfielders and won multiple Champions Leagues.'),

  (v_league, v_fp, 'Which Swiss striker scored 106 Bundesliga goals for Borussia Dortmund between 1991 and 1999?',
   '["Karl-Heinz Riedle","Stéphane Chapuisat","Ole Gunnar Solskjær","Jan Koller"]', 1, 'hard',
   'Stéphane Chapuisat is a Swiss striker who scored 106 Bundesliga goals for Borussia Dortmund (1991–99) and is one of the most important foreign players in the club''s history. He helped them win the Champions League in 1997 and was Switzerland''s greatest striker of his era.'),

  (v_league, v_fp, 'Leroy Sané came through which Bundesliga club before joining Manchester City?',
   '["Hoffenheim","Schalke 04","Bayern Munich","Borussia Mönchengladbach"]', 1, 'medium',
   'Leroy Sané came through Schalke 04''s youth academy before joining Manchester City in 2016 for £37 million. He later returned to Germany to sign for Bayern Munich in 2020 for €45 million.'),

  (v_league, v_fp, 'Which goalkeeper famously won the Champions League with Borussia Dortmund and later joined Bayern Munich?',
   '["Oliver Kahn","Jens Lehmann","Sven Ulreich","Michael Rensing"]', 1, 'medium',
   'Jens Lehmann won the Champions League with Borussia Dortmund in 1997 and later won the Premier League with Arsenal in 2003–04 (the Invincibles). His career spanned both German and English football at the highest level.'),

  (v_league, v_fp, 'Bayern Munich''s "Mia san Mia" motto literally translates to what in English?',
   '["We are the best","We are what we are","We are the champions","We are always here"]', 1, 'easy',
   '"Mia san Mia" is Bavarian dialect for "We are who we are" — a phrase that encapsulates Bayern Munich''s self-confident identity and refusal to compromise their values or history.'),

  (v_league, v_fp, 'Who was the first Bundesliga player to score 400 Bundesliga goals?',
   '["Gerd Müller","Robert Lewandowski","Klaus Fischer","No player has scored 400"]', 3, 'hard',
   'No player in Bundesliga history has scored 400 Bundesliga goals. Gerd Müller''s 365 is the all-time record. This question tests awareness that the milestone has not been reached.'),

  (v_league, v_fp, 'Erling Haaland scored 86 goals in how many appearances for Borussia Dortmund?',
   '["67","89","96","101"]', 1, 'medium',
   'Erling Haaland scored 86 goals in 89 appearances for Borussia Dortmund (January 2020 to June 2022) — an extraordinary strike rate that made him one of the most valuable players in world football.');

  -- ============================================================
  -- DER KLASSIKER (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_dk, 'What is "Der Klassiker" in German football?',
   '["Bayern Munich vs Schalke","Bayern Munich vs Borussia Dortmund","Borussia Dortmund vs Schalke","Hamburger SV vs Bayern Munich"]', 1, 'easy',
   '"Der Klassiker" is the name given to the fixture between FC Bayern Munich and Borussia Dortmund — Germany''s most watched and significant match, representing the rivalry between Bavaria and the Ruhr.'),

  (v_league, v_dk, 'The 2013 Champions League Final was an all-German affair. Which German clubs contested it?',
   '["Bayern Munich vs Schalke","Bayern Munich vs Borussia Dortmund","Borussia Dortmund vs Bayer Leverkusen","Bayern Munich vs Hamburger SV"]', 1, 'easy',
   'The 2013 Champions League Final at Wembley was contested between Bayern Munich and Borussia Dortmund — the first all-German European Cup Final since Bayern beat Hamburg in 1976. Bayern won 2–1.'),

  (v_league, v_dk, 'Robert Lewandowski scored all four goals for Borussia Dortmund in their 2013 Champions League semi-final against Real Madrid. What was the score of that first leg?',
   '["3–0","4–0","4–1","5–1"]', 2, 'hard',
   'Robert Lewandowski scored all four goals as Borussia Dortmund beat Real Madrid 4–1 at Signal Iduna Park in the first leg of their 2013 Champions League semi-final. It is one of the greatest individual semi-final performances in the tournament''s history. Dortmund advanced to the final on aggregate but lost to Bayern Munich.'),

  (v_league, v_dk, 'Who scored the winning goal for Bayern Munich in the 2013 Champions League Final against Dortmund?',
   '["Thomas Müller","Mario Mandžukić","Arjen Robben","Franck Ribéry"]', 2, 'hard',
   'Arjen Robben scored the winning goal in the 88th minute of the 2013 Champions League Final against Borussia Dortmund at Wembley. Bayern had previously missed a penalty through Robben in extra time.'),

  (v_league, v_dk, 'Jürgen Klopp''s Dortmund beat Bayern Munich twice in the Bundesliga in 2011–12. What was this era called?',
   '["The Dortmund Dominance","The Klopp Era","Die Goldene Zeit","The Gegenpressing Revolution"]', 3, 'hard',
   'Klopp''s "Gegenpressing" revolution at Borussia Dortmund produced one of German football''s most exciting eras. The 2011–12 Dortmund side, with Lewandowski, Kagawa, and Götze, beat Bayern in both Bundesliga encounters.'),

  (v_league, v_dk, 'Bayern Munich won the 2012 DFB-Pokal Final against Dortmund at their own ground (Allianz Arena). True or false?',
   '["True","False — it was at a neutral ground","False — Dortmund won","False — it was at Wembley"]', 1, 'easy',
   'The DFB-Pokal Final is always played at the Olympiastadion in Berlin. In 2012, Dortmund beat Bayern 5–2 in a stunning final — a result that still burns for Bayern fans.'),

  (v_league, v_dk, 'How many Der Klassiker matches did Jürgen Klopp win against Bayern Munich as Dortmund manager?',
   '["3","5","7","9"]', 2, 'hard',
   'Jürgen Klopp won approximately 7 Der Klassiker matches against Bayern Munich during his seven seasons at Borussia Dortmund (2008–2015), though the exact count depends on whether DFB-Pokal and Champions League matches are included.'),

  (v_league, v_dk, 'The first Bundesliga "Klassiker" between Bayern Munich and Borussia Dortmund was played in which season?',
   '["1965–66","1968–69","1970–71","1975–76"]', 0, 'hard',
   'Bayern Munich joined the Bundesliga in 1965–66 (their first season after promotion), so the very first Bundesliga Klassiker was played that season. Borussia Dortmund had been in the Bundesliga since 1963.'),

  (v_league, v_dk, 'What was the score of the famous Der Klassiker in November 2012, Bayern''s biggest ever Bundesliga defeat?',
   '["Bayern 1–4 BVB","Bayern 3–5 BVB","Bayern 0–4 BVB","Bayern 2–5 BVB"]', 1, 'hard',
   'Borussia Dortmund beat Bayern Munich 3-2 in multiple Bundesliga encounters during the Klopp era. The most emphatic Klassiker result was a Dortmund win when Klopp''s pressing overwhelmed Jupp Heynckes''s side.'),

  (v_league, v_dk, 'Mario Götze played for both Bayern Munich and Borussia Dortmund. Which club did he score for in a Der Klassiker?',
   '["Only Dortmund","Only Bayern","Both clubs","Neither — he was injured"]', 2, 'hard',
   'Mario Götze played for Borussia Dortmund (2009–2013 and 2016–2021) and Bayern Munich (2013–2016), scoring in Der Klassiker for both clubs during his career.'),

  (v_league, v_dk, 'Pep Guardiola''s Bayern Munich dominated Der Klassiker. How did his overall record against Dortmund compare to his predecessors?',
   '["Much better — he won all Klassikers","Better — he won about 70%","Similar to Heynckes","Worse — Klopp still had the edge"]', 3, 'hard',
   'Despite Pep Guardiola''s Bayern Munich dominance, Jürgen Klopp''s Dortmund remained competitive in Der Klassiker. Klopp''s superior tactical understanding of Guardiola''s system gave Dortmund a better-than-expected record.'),

  (v_league, v_dk, 'In which year did Bayern Munich beat Borussia Dortmund 7-0 in Der Klassiker?',
   '["2015","2016","2017","No such result has ever occurred"]', 3, 'hard',
   'Bayern Munich have never beaten Borussia Dortmund 7-0 in Der Klassiker. Bayern''s biggest ever Bundesliga win against Dortmund was approximately 5-0 in various seasons.'),

  (v_league, v_dk, 'The DFB-Pokal semi-final Der Klassiker in 2014 ended 0–2. Who won?',
   '["Bayern Munich","Borussia Dortmund","The match was drawn","No Der Klassiker semi-final happened in 2014"]', 0, 'hard',
   'Bayern Munich beat Borussia Dortmund in the DFB-Pokal in multiple seasons during the Klopp era. The cup fixtures between the clubs have produced some of the most memorable recent German football moments.'),

  (v_league, v_dk, 'Which Dortmund midfielder controlled the midfield in Der Klassiker during the club''s golden Klopp era?',
   '["İlkay Gündoğan","Mats Hummels","Sven Bender","Kevin Großkreutz"]', 0, 'medium',
   'İlkay Gündoğan was the creative pivot in Borussia Dortmund''s midfield during their 2011–12 peak. He later moved to Manchester City and became a key player under Pep Guardiola.'),

  (v_league, v_dk, 'Bayern Munich won Der Klassiker by what aggregate score in the 2019–20 season?',
   '["Bayern won both by 4-0","Bayern won both matches","Dortmund won the first, Bayern the second","Both matches were draws"]', 1, 'hard',
   'In 2019–20 Bundesliga, Bayern Munich won both Der Klassiker encounters, helping them to their eighth consecutive Bundesliga title. The most notable match saw Erling Haaland score on his BVB debut but Bayern still won.'),

  (v_league, v_dk, 'What is the seating capacity of Signal Iduna Park, where Der Klassiker''s Dortmund home leg is played?',
   '["75,000","81,365","72,500","66,000"]', 1, 'medium',
   'Signal Iduna Park (Westfalenstadion) has a capacity of 81,365 for Bundesliga matches — the largest in Germany and one of the largest in Europe. For European matches it is limited to 66,099.'),

  (v_league, v_dk, 'Who holds the record for most goals scored in Der Klassiker across all competitions?',
   '["Gerd Müller","Robert Lewandowski","Thomas Müller","Pierre-Emerick Aubameyang"]', 1, 'hard',
   'Robert Lewandowski scored 14 goals in Der Klassiker across his time at Borussia Dortmund and Bayern Munich — the most by any player in the fixture''s history.'),

  (v_league, v_dk, 'In the 2023 Champions League Final, Borussia Dortmund played Bayern Munich. True or false?',
   '["True","False — Dortmund played Real Madrid","False — Bayern played Real Madrid","False — Neither club reached the final"]', 1, 'easy',
   'Borussia Dortmund reached the 2024 Champions League Final (not 2023), where they lost to Real Madrid 2–0 at Wembley. Bayern Munich were eliminated in the semi-finals by Real Madrid in 2024.'),

  (v_league, v_dk, 'How many goals did Borussia Dortmund score against Bayern Munich in their 2012 DFB-Pokal Final win?',
   '["3","4","5","6"]', 2, 'easy',
   'Borussia Dortmund beat Bayern Munich 5–2 in the 2012 DFB-Pokal Final at the Olympiastadion in Berlin — one of the most extraordinary cup final results in German football history.'),

  (v_league, v_dk, 'Who became the youngest player to score in Der Klassiker?',
   '["Mario Götze","Mats Hummels","Jadon Sancho","Jude Bellingham"]', 3, 'hard',
   'Jude Bellingham became the youngest player to score in Der Klassiker when he netted for Borussia Dortmund at the age of 17 in May 2021 — one of several records the English teenager set during his time at BVB.'),

  (v_league, v_dk, 'Hansi Flick''s first Der Klassiker as Bayern manager ended with what result?',
   '["Bayern 4–0 BVB","Bayern 3–2 BVB","Bayern 3–1 BVB","BVB 1–0 Bayern"]', 0, 'hard',
   'Hansi Flick''s Bayern Munich beat Borussia Dortmund 4–0 in the November 2020 Bundesliga Klassiker in an emphatic statement victory. Flick''s Bayern went on to win the Champions League that season.'),

  (v_league, v_dk, 'The "Klassiker" typically generates the highest Bundesliga TV viewing figures. Approximately how many people watch in Germany?',
   '["5 million","9 million","13 million","20 million"]', 1, 'hard',
   'Der Klassiker typically draws around 9-10 million TV viewers in Germany for Bundesliga matches — the highest rating of any regular Bundesliga fixture and one of the most watched club matches in European football.'),

  (v_league, v_dk, 'Mats Hummels played for both clubs in Der Klassiker. How many times did he switch between them?',
   '["Once (BVB to Bayern)","Twice (BVB→Bayern→BVB)","Three times","He only played for Dortmund"]', 1, 'medium',
   'Mats Hummels played for Borussia Dortmund (2008–16), then moved to Bayern Munich (2016–19) before returning to BVB (2019–2024), experiencing Der Klassiker from both sides twice.'),

  (v_league, v_dk, 'What is Bayern Munich''s home ground called?',
   '["Olympiastadion","Deutsche Telekom Arena","Allianz Arena","Signal Iduna Park"]', 2, 'easy',
   'Bayern Munich play at the Allianz Arena, opened in 2005. It is named after Allianz insurance company and has a distinctive inflatable exterior that can be lit in red (Bayern) or blue (Germany national team).'),

  (v_league, v_dk, 'Der Klassiker in the 2010–11 season was crucial for the title. Who won the Bundesliga that season?',
   '["Bayern Munich","Borussia Dortmund","Schalke 04","Bayer Leverkusen"]', 1, 'medium',
   'Borussia Dortmund won the 2010–11 Bundesliga under Jürgen Klopp — their first in nine years and the beginning of their brief dominance that included back-to-back titles in 2010–11 and 2011–12.'),

  (v_league, v_dk, 'Which Dortmund player scored a stunning long-range winner against Bayern in Der Klassiker in 2016?',
   '["Henrikh Mkhitaryan","Marco Reus","Pierre-Emerick Aubameyang","Shinji Kagawa"]', 0, 'hard',
   'Henrikh Mkhitaryan scored some memorable goals in Der Klassiker during his time at Dortmund (2013–16) before moving to Manchester United. His technical quality was perfectly suited to Dortmund''s attacking style.'),

  (v_league, v_dk, 'In terms of head-to-head Bundesliga records, which club leads in Der Klassiker historically?',
   '["Bayern Munich clearly leads","Borussia Dortmund leads","They are about equal","Statistics aren''t tracked"]', 0, 'hard',
   'Bayern Munich lead the head-to-head Bundesliga record in Der Klassiker by a significant margin, having won approximately twice as many encounters as Borussia Dortmund in the league fixture history.'),

  (v_league, v_dk, 'Thomas Müller has scored the most goals against Borussia Dortmund for Bayern Munich. How many?',
   '["7","9","11","13"]', 2, 'hard',
   'Thomas Müller has scored over 11 goals against Borussia Dortmund in Der Klassiker across all competitions, making him the highest-scoring Bayern player in the fixture. His "Raumdeuter" positioning is perfectly suited to exploiting BVB''s high defensive line.'),

  (v_league, v_dk, 'When Jürgen Klopp left Dortmund in 2015, which team did he join — and beat Bayern in their first "Der Klassiker" equivalent?',
   '["Real Madrid","Arsenal","Liverpool","Manchester City"]', 2, 'hard',
   'Jürgen Klopp joined Liverpool in October 2015. He beat Bayern Munich in the 2019–20 Champions League Round of 16, with Liverpool winning 4–0 on aggregate — a stunning result at Anfield.'),

  (v_league, v_dk, 'The first ever Bayern vs BVB meeting in the Bundesliga resulted in which club winning?',
   '["Bayern Munich","Borussia Dortmund","A draw","Records unclear"]', 1, 'hard',
   'In the early Bundesliga years, the fixture records between Bayern and Dortmund favoured different clubs. Historical records from 1965–66 show the competition was initially closer than in later decades of Bayern dominance.');

  -- ============================================================
  -- RECORDS & STATS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_rs, 'Who holds the record for most Bundesliga goals?',
   '["Karl-Heinz Rummenigge","Robert Lewandowski","Klaus Fischer","Gerd Müller"]', 3, 'easy',
   'Gerd Müller scored 365 Bundesliga goals for Bayern Munich — the all-time record. His goals-per-game ratio of approximately 0.73 per match may never be surpassed.'),

  (v_league, v_rs, 'What is the record for most consecutive Bundesliga titles?',
   '["9","10","11","12"]', 2, 'easy',
   'Bayern Munich won 11 consecutive Bundesliga titles from 2012–13 to 2022–23 — the longest winning streak in the history of any major European top-flight football league.'),

  (v_league, v_rs, 'Robert Lewandowski set the single-season Bundesliga record of 41 goals in which season?',
   '["2018–19","2019–20","2020–21","2021–22"]', 2, 'easy',
   'Robert Lewandowski scored 41 Bundesliga goals in the 2020–21 season for Bayern Munich, breaking Gerd Müller''s record of 40 from 1971–72. He scored in the final match of the season to break the record.'),

  (v_league, v_rs, 'Hamburger SV''s unbroken Bundesliga run lasted how many seasons?',
   '["42","49","55","62"]', 2, 'medium',
   'Hamburger SV played in every Bundesliga season from the inaugural 1963–64 campaign until they were relegated in 2018 — an unbroken run of 55 seasons in the top flight, a European record.'),

  (v_league, v_rs, 'What is the record for most Bundesliga appearances by a single player?',
   '["567","602","656","702"]', 1, 'hard',
   'Karl-Heinz Körbel made 602 Bundesliga appearances for Eintracht Frankfurt, the record for most appearances by any player at a single club and the overall appearances record in Bundesliga history.'),

  (v_league, v_rs, 'Signal Iduna Park in Dortmund is the largest stadium in Germany. What is its capacity for Bundesliga matches?',
   '["72,500","75,023","81,365","85,000"]', 2, 'easy',
   'Signal Iduna Park has a capacity of 81,365 for domestic Bundesliga matches, incorporating standing areas. For UEFA competition it is reduced to around 66,099 to comply with all-seater requirements.'),

  (v_league, v_rs, 'How many clubs compete in the Bundesliga each season?',
   '["16","18","20","22"]', 1, 'easy',
   'The Bundesliga consists of 18 clubs, making it unique among Europe''s top leagues. This smaller format means each club plays 34 matches per season, with three clubs relegated and three promoted from the 2. Bundesliga.'),

  (v_league, v_rs, 'Which Bundesliga club was the first to win the competition in back-to-back seasons?',
   '["Bayern Munich (1969–70)","Borussia Mönchengladbach (1975–77)","1. FC Köln (1977–78)","Hamburger SV (1982–83)"]', 0, 'hard',
   'Bayern Munich won back-to-back Bundesliga titles in 1969–70 and 1971–72 (not consecutive), while several clubs achieved back-to-back titles. Bayern''s first consecutive titles in the modern era came in 1985–86 and 1986–87.'),

  (v_league, v_rs, 'What is the highest scoring Bundesliga match in history?',
   '["9–0","10–0","11–1","12–0"]', 3, 'hard',
   'The highest scoring Bundesliga match was a 12–0 result achieved in the early Bundesliga years. More recently, Borussia Mönchengladbach beat Borussia Dortmund 12–0 in the 1977–78 season.'),

  (v_league, v_rs, 'Bayern Munich''s record Bundesliga season in terms of points was in which year?',
   '["2012–13","2015–16","2019–20","2022–23"]', 2, 'hard',
   'Bayern Munich accumulated 82 points in the 2019–20 Bundesliga season under Hansi Flick, equalling their own record. They also scored 100 goals, setting a Bundesliga goals record that season.'),

  (v_league, v_rs, 'How many goals did Bundesliga clubs score in the record-breaking 2015–16 season?',
   '["820","863","902","956"]', 2, 'hard',
   'The 2015–16 Bundesliga season produced over 900 goals — approximately 2.9 goals per game. The Bundesliga consistently ranks among Europe''s highest-scoring top-flight leagues due to the open, attacking style of play.'),

  (v_league, v_rs, 'Gerd Müller''s goals-per-game ratio in the Bundesliga (365 goals, 427 games) is approximately what?',
   '["0.61","0.73","0.85","0.91"]', 2, 'medium',
   'Gerd Müller''s Bundesliga goals-per-game ratio is approximately 0.85 (365 goals in 427 games) — making him the most prolific goalscorer per game in Bundesliga history. Robert Lewandowski''s career ratio at Bayern was also above 0.80.'),

  (v_league, v_rs, 'Which Bundesliga season saw the most red cards issued?',
   '["2000–01","2005–06","2012–13","2018–19"]', 0, 'hard',
   'German football has historically had high disciplinary rates. The early 2000s Bundesliga seasons featured more physical play and higher red card counts. Exact season records vary by source.'),

  (v_league, v_rs, 'Bayern Munich have won the DFB-Pokal how many times?',
   '["16","18","20","22"]', 2, 'medium',
   'Bayern Munich have won the DFB-Pokal (German Cup) 20 times — by far the most of any German club. They have completed numerous domestic doubles combining Bundesliga and DFB-Pokal wins.'),

  (v_league, v_rs, 'Which player scored the most Bundesliga hat-tricks in a single season?',
   '["Gerd Müller","Robert Lewandowski","Klaus Fischer","Sandra Mingers"]', 0, 'hard',
   'Gerd Müller set numerous Bundesliga scoring records including multiple hat-tricks in a season. Robert Lewandowski''s 2019–20 and 2020–21 seasons both saw multiple hat-tricks, but Müller''s 1971–72 season remains exceptional.'),

  (v_league, v_rs, 'The Bundesliga''s average attendance is the highest of any football league in the world. What is it approximately?',
   '["38,000","43,000","47,000","51,000"]', 1, 'medium',
   'The Bundesliga consistently records the highest average attendance of any football league worldwide — typically around 43,000 per match. The passionate fan culture, affordable tickets, and standing sections contribute to this.'),

  (v_league, v_rs, 'How many Champions League titles have Bundesliga clubs won in total?',
   '["5","7","8","9"]', 1, 'hard',
   'German clubs have won the European Cup/Champions League eight times: Bayern Munich (1974, 1975, 1976, 2001, 2013, 2020 — 6 titles) and Borussia Dortmund (1997 — 1 title) and Hamburger SV (1983 — 1 title).'),

  (v_league, v_rs, 'What percentage of Bundesliga clubs are member-owned (applying the 50+1 rule)?',
   '["Around 50%","Around 70%","Around 85%","100%"]', 2, 'hard',
   'Approximately 85-90% of Bundesliga clubs adhere to the 50+1 rule, with the exceptions being Bayer Leverkusen (Bayer AG ownership) and Wolfsburg (Volkswagen), who were grandfathered in before the rule was codified.'),

  (v_league, v_rs, 'Which Bundesliga season saw Bayern Munich achieve a "Meisterschale" clean sweep (Bundesliga, DFB-Pokal, Champions League)?',
   '["2012–13","2019–20","2022–23","2015–16"]', 0, 'medium',
   'Bayern Munich won the historic Treble in 2012–13 under Jupp Heynckes: Bundesliga, DFB-Pokal, and Champions League (beating Borussia Dortmund in all three knockout rounds). They repeated the feat in 2019–20 under Hansi Flick.'),

  (v_league, v_rs, 'What is the record for lowest points total by a Bundesliga champion?',
   '["45","47","49","52"]', 0, 'hard',
   'In the early two-points-for-a-win era, Bundesliga titles were won with 45-50 points. In the modern 3-points era (since 1995), no Bundesliga title has been won with fewer than approximately 68 points.'),

  (v_league, v_rs, 'The Bundesliga''s fastest ever goal was scored in how many seconds?',
   '["8 seconds","11 seconds","14 seconds","18 seconds"]', 1, 'hard',
   'The fastest Bundesliga goal was scored in 11 seconds — by Karim Bellarabi for Bayer Leverkusen against Borussia Dortmund on 23 August 2014. He received the kick-off and ran straight through to score.'),

  (v_league, v_rs, 'How many Bundesliga titles has Borussia Dortmund won in total?',
   '["5","7","8","10"]', 2, 'medium',
   'Borussia Dortmund have won the Bundesliga eight times — in 1956, 1957, 1963 (pre-Bundesliga era German championship) and 1995, 1996, 2002, 2011, 2012 in the Bundesliga era.'),

  (v_league, v_rs, 'The Bundesliga was the first major European league to return after COVID-19 in 2020. What helped this happen?',
   '["Games behind closed doors at a purpose-built facility","Rapid testing protocols and strict quarantine bubbles","Only domestic clubs were allowed","Foreign players returned to their home countries"]', 1, 'medium',
   'The Bundesliga resumed in May 2020 under a strict testing and hygiene concept — regular COVID testing, quarantine bubbles, and games played behind closed doors. It became a template for other leagues returning safely.'),

  (v_league, v_rs, 'Bayern Munich''s record home win in the Bundesliga was which score?',
   '["9–1","10–1","11–0","12–1"]', 0, 'hard',
   'Bayern Munich have achieved 9-1 wins in the Bundesliga (most notably against their traditional rivals), but their exact record home victory depends on the era. Modern era dominance has produced several 8-0 and 9-0 wins.'),

  (v_league, v_rs, 'Borussia Dortmund''s "Gelbe Wand" (Yellow Wall) at Signal Iduna Park holds how many standing fans?',
   '["18,000","21,000","25,000","30,000"]', 2, 'medium',
   'The "Gelbe Wand" (Yellow Wall) is the massive standing terrace at Signal Iduna Park, holding approximately 25,000 standing fans. It is the largest standing terrace in European football and creates an extraordinary atmosphere.'),

  (v_league, v_rs, 'Which Bundesliga club is known for their fan-owned structure and having 81,000 registered members?',
   '["Borussia Dortmund","Bayern Munich","Schalke 04","Borussia Mönchengladbach"]', 1, 'hard',
   'Bayern Munich have over 300,000 registered members (as of 2023) — the largest of any sports club in Germany and one of the largest in the world. Borussia Dortmund has approximately 155,000 members.'),

  (v_league, v_rs, 'What is the penalty used to resolve Bundesliga championship ties?',
   '["Head-to-head record","Goal difference","Away goals","Goals scored"]', 1, 'easy',
   'In the Bundesliga, ties in points are resolved first by goal difference, then by total goals scored. This has occasionally produced dramatic final-day title-deciders based on a single goal difference.'),

  (v_league, v_rs, 'Wolfsburg''s title-winning 2008–09 season is remembered for which strike partnership?',
   '["Lewandowski and Aubameyang","Dzeko and Grafite","Müller and Mandzukic","Schürrle and Weghorst"]', 1, 'medium',
   'Edin Džeko and Grafite scored a combined 54 Bundesliga goals in the 2008–09 season for Wolfsburg — one of the most prolific strike partnerships in Bundesliga history. Volkswagen''s investment powered their only title win.'),

  (v_league, v_rs, 'Which Bundesliga club''s academy is considered the best in Germany, having produced the most Germany international players?',
   '["Borussia Dortmund","Schalke 04","Bayern Munich","Hamburger SV"]', 0, 'medium',
   'Borussia Dortmund''s academy has produced the most Germany youth international players of any club in Germany, including names like Mario Götze, Marc Bartra, and Jude Bellingham (England) in recent years.'),

  (v_league, v_rs, 'What is the record for consecutive matches without defeat in the Bundesliga?',
   '["36","42","50","53"]', 1, 'hard',
   'Bayern Munich went 42 consecutive Bundesliga matches without defeat under Hansi Flick (2019–20 and 2020–21), the longest unbeaten run in Bundesliga history.');

  -- ============================================================
  -- MANAGERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_mg, 'How many Bundesliga titles did Jupp Heynckes win as Bayern Munich manager?',
   '["2","3","4","5"]', 2, 'medium',
   'Jupp Heynckes won four Bundesliga titles as Bayern Munich manager (in two separate spells: 1988–91 and 2011–13), including the historic Treble in 2012–13. He is considered one of Germany''s greatest coaches.'),

  (v_league, v_mg, 'Pep Guardiola managed Bayern Munich from 2013 to 2016. How many Bundesliga titles did he win?',
   '["1","2","3","4"]', 2, 'easy',
   'Pep Guardiola won three consecutive Bundesliga titles at Bayern Munich (2013–14, 2014–15, 2015–16), though he was criticised for not winning the Champions League during his tenure.'),

  (v_league, v_mg, 'Jürgen Klopp''s philosophy at Borussia Dortmund was centred on what concept?',
   '["Tiki-taka","Catenaccio","Gegenpressing","Route one football"]', 2, 'easy',
   '"Gegenpressing" (counter-pressing) — immediately pressing opponents when possession is lost — was the cornerstone of Klopp''s success at both Borussia Dortmund and Liverpool. He called it "the best playmaker in the world."'),

  (v_league, v_mg, 'Hansi Flick won the Champions League with Bayern Munich in which season?',
   '["2018–19","2019–20","2020–21","2021–22"]', 1, 'medium',
   'Hansi Flick won the 2019–20 Champions League with Bayern Munich, completing an extraordinary sextuple (Bundesliga, DFB-Pokal, Champions League, DFB Supercup, UEFA Super Cup, Club World Cup). He was appointed interim before being confirmed as head coach.'),

  (v_league, v_mg, 'Otto Rehhagel managed Werder Bremen to what success in the 1990s?',
   '["Two Bundesliga titles","One Champions League","Three DFB-Pokal wins","One UEFA Cup"]', 0, 'medium',
   'Otto Rehhagel managed Werder Bremen to two Bundesliga titles (1987–88 and 1992–93) and the DFB-Pokal, establishing them as one of Germany''s top clubs. He later famously managed Greece to their extraordinary Euro 2004 triumph.'),

  (v_league, v_mg, 'Which manager revolutionised Bayer Leverkusen and guided them to their first ever Bundesliga title in 2023–24?',
   '["Andi Brehme","Julian Nagelsmann","Xabi Alonso","Thomas Tuchel"]', 2, 'easy',
   'Xabi Alonso was appointed Bayer Leverkusen manager in October 2022 and transformed the club from relegation candidates to Bundesliga champions in 2023–24, winning the title unbeaten.'),

  (v_league, v_mg, 'Ottmar Hitzfeld managed Borussia Dortmund to the Champions League in 1997 and then managed which other German club?',
   '["Schalke 04","Hamburger SV","Bayern Munich","Bayer Leverkusen"]', 2, 'medium',
   'Ottmar Hitzfeld managed Borussia Dortmund to the 1997 Champions League and then moved to Bayern Munich, where he won two Champions League titles (2000–01) and multiple Bundesliga titles.'),

  (v_league, v_mg, 'Thomas Tuchel managed Borussia Dortmund before which club? (His career path after Dortmund)',
   '["PSG, Chelsea, Bayern Munich","Liverpool, Arsenal, Bayern Munich","Manchester United, Real Madrid, Bayern Munich","PSG, Tottenham, Bayern Munich"]', 0, 'medium',
   'Thomas Tuchel managed Mainz 05, Borussia Dortmund (2015–17), PSG (2018–20), Chelsea (winning the Champions League in 2021), and then Bayern Munich (2023–24).'),

  (v_league, v_mg, 'Which Bundesliga manager is known for the "heavy metal football" description?',
   '["Pep Guardiola","Thomas Tuchel","Jürgen Klopp","Jupp Heynckes"]', 2, 'easy',
   'Jürgen Klopp described his football as "heavy metal" in contrast to Pep Guardiola''s "classical music" style. The energetic, intense pressing approach was a perfect description of his Dortmund and Liverpool teams.'),

  (v_league, v_mg, 'Giovanni Trapattoni managed Bayern Munich from 1994 to 1995. What was his style?',
   '["Attacking total football","Defensive Italian catenaccio","High-press English style","Tiki-taka"]', 1, 'medium',
   'Giovanni Trapattoni brought his traditional Italian defensive approach to Bayern Munich, which clashed somewhat with Bundesliga attacking traditions. He won the UEFA Cup in 1996 but did not win the Bundesliga.'),

  (v_league, v_mg, 'Niko Kovač was sacked by Bayern Munich mid-season in 2019. Who replaced him?',
   '["Thomas Tuchel","Julian Nagelsmann","Hansi Flick","Carlo Ancelotti"]', 2, 'medium',
   'Hansi Flick replaced Niko Kovač as Bayern Munich''s interim manager in November 2019. His early success was so impressive that he was confirmed as head coach, going on to win the sextuple in 2019–20.'),

  (v_league, v_mg, 'Rudi Völler managed which Bundesliga club as sporting director before becoming Germany manager?',
   '["Bayern Munich","Bayer Leverkusen","Borussia Dortmund","Schalke 04"]', 1, 'hard',
   'Rudi Völler served as sporting director of Bayer Leverkusen from 2005 to 2022 before taking over as Germany national team manager in 2023. He led Leverkusen through the era that eventually culminated in their 2023–24 Bundesliga title.'),

  (v_league, v_mg, 'Felix Magath managed Bayern Munich in the mid-2000s. What nickname did he earn from players?',
   '["Quälix (Quäl Felix/Torture Felix)","Das Genie","Der Taktiker","Der Macher"]', 0, 'hard',
   'Felix Magath earned the nickname "Quälix" (a portmanteau of "quälen" meaning to torture/torment and his name Felix) for his notoriously brutal training sessions. Despite this, he won two Bundesliga titles with Bayern Munich.'),

  (v_league, v_mg, 'Julian Nagelsmann was the youngest manager ever to achieve what in the Bundesliga?',
   '["Win the Bundesliga","Take a club to the top flight","Manage in European competition with Hoffenheim","Sign a player over €50m"]', 2, 'medium',
   'Julian Nagelsmann became the youngest ever coach to manage in the Bundesliga and then the youngest to qualify for the Champions League with Hoffenheim (2016–17), before later managing RB Leipzig and Bayern Munich.'),

  (v_league, v_mg, 'Which former German international managed Schalke 04 for many years in the 2000s?',
   '["Ralf Rangnick","Mirko Slomka","Huub Stevens","Fred Rutten"]', 2, 'hard',
   'Huub Stevens is a Dutch manager who managed Schalke 04 multiple times and is beloved in Gelsenkirchen for saving the club from relegation and developing their playing style in the early 2000s.'),

  (v_league, v_mg, 'Carlo Ancelotti managed Bayern Munich from 2016 to 2017. What was notable about his time there?',
   '["He won the Champions League","He was sacked after a Champions League embarrassment","He won the Bundesliga unbeaten","He turned down Real Madrid to stay"]', 1, 'medium',
   'Carlo Ancelotti was sacked by Bayern Munich in September 2017 after they were embarrassed 3–0 by PSG in the Champions League group stage. He had previously won the Bundesliga in his first season (2016–17).'),

  (v_league, v_mg, 'Ralf Rangnick is known for developing what style of play at RB Leipzig?',
   '["Possession tiki-taka","High press and structured pressing","Counterattack catenaccio","Direct long-ball"]', 1, 'medium',
   'Ralf Rangnick developed a highly structured high-press and counter-pressing system at RB Leipzig and across the Red Bull football network. His methods influenced many coaches, including Thomas Tuchel and Jürgen Klopp.'),

  (v_league, v_mg, 'Armin Veh managed which club to the Bundesliga title in 2006–07?',
   '["Werder Bremen","Bayer Leverkusen","VfB Stuttgart","Schalke 04"]', 2, 'medium',
   'Armin Veh managed VfB Stuttgart to their most recent Bundesliga title in 2006–07, with a young squad featuring Mario Gomez, Sami Khedira, and Cacau. He was named the Bundesliga coach of the year.'),

  (v_league, v_mg, 'Matthias Sammer is known for being manager of which club?',
   '["Werder Bremen","Borussia Dortmund","Schalke 04","VfL Wolfsburg"]', 1, 'medium',
   'Matthias Sammer managed Borussia Dortmund from 2000 to 2004, winning the Bundesliga in 2001–02. He later became Bayern Munich''s sporting director and played a key role in their development during their dominant era.'),

  (v_league, v_mg, 'Who replaced Jürgen Klopp at Borussia Dortmund in 2015?',
   '["Thomas Tuchel","Lucien Favre","Peter Bosz","Edin Terzić"]', 0, 'medium',
   'Thomas Tuchel replaced Jürgen Klopp at Borussia Dortmund in May 2015. Despite reaching the DFB-Pokal Final, he was sacked in May 2017 after a turbulent relationship with the club''s management.'),

  (v_league, v_mg, 'Which Dutch manager guided Borussia Dortmund to the 1995 and 1996 Bundesliga titles?',
   '["Johan Cruyff","Louis van Gaal","Ottmar Hitzfeld","Christoph Daum"]', 2, 'hard',
   'Ottmar Hitzfeld (German, not Dutch) guided Borussia Dortmund to back-to-back Bundesliga titles in 1994–95 and 1995–96, and then the Champions League in 1996–97. He is one of Germany''s greatest managers.'),

  (v_league, v_mg, 'Joachim Löw managed the Germany national team for how many years?',
   '["10","12","14","15"]', 3, 'medium',
   'Joachim Löw managed Germany from 2006 to 2021 — 15 years. In that time he won the 2014 World Cup, reached multiple semi-finals and finals of major tournaments, but also suffered notable defeats at Euro 2016 and World Cup 2018.'),

  (v_league, v_mg, 'Which Bundesliga manager is known for his PhD in sports science and academic approach?',
   '["Julian Nagelsmann","Roger Schmidt","Pal Dardai","Thomas Tuchel"]', 3, 'hard',
   'Thomas Tuchel is known for his highly analytical, detailed approach to football. Julian Nagelsmann also has extensive theoretical knowledge. Tuchel''s attention to detail and video analysis set him apart as a modern German manager.'),

  (v_league, v_mg, 'Stephan Chazel (Eintracht Frankfurt''s 2022 Europa League winning manager''s full name)?',
   '["Adi Hütter","Oliver Glasner","Niko Kovač","Bruno Labbadia"]', 1, 'medium',
   'Oliver Glasner managed Eintracht Frankfurt to their remarkable Europa League victory in 2021–22, defeating Rangers on penalties in the final. His flexible tactical approach and man-management were key to the triumph.'),

  (v_league, v_mg, 'Which Bayern Munich manager won the most consecutive Bundesliga titles?',
   '["Ottmar Hitzfeld","Pep Guardiola","Hansi Flick","Jupp Heynckes"]', 1, 'medium',
   'Pep Guardiola won three consecutive Bundesliga titles (2013–14, 2014–15, 2015–16) during his Bayern tenure — the highest consecutive run of any Bayern manager, though Hansi Flick and subsequent managers extended Bayern''s overall consecutive run.'),

  (v_league, v_mg, 'Heiner Backhaus managed which Bundesliga underdog to Europa League competition?',
   '["Union Berlin","Augsburg","Mainz 05","SC Freiburg"]', 0, 'hard',
   'Union Berlin — managed by Urs Fischer (not Backhaus) — had an extraordinary rise from the third tier to Bundesliga champions contenders and Champions League participation (2023–24), one of football''s most remarkable stories.'),

  (v_league, v_mg, 'Edin Terzić led Borussia Dortmund to the Champions League Final in 2024. What had he previously won with them?',
   '["The Bundesliga 2022","The DFB-Pokal 2021","The UEFA Super Cup 2022","The Club World Cup 2023"]', 1, 'medium',
   'Edin Terzić led Borussia Dortmund to DFB-Pokal victory in 2021 in his first managerial stint, then returned to guide them to the 2024 Champions League Final, where they lost 2–0 to Real Madrid.'),

  (v_league, v_mg, 'Which Bundesliga manager holds the record for most Bundesliga wins?',
   '["Ottmar Hitzfeld","Udo Lattek","Jupp Heynckes","Pep Guardiola"]', 1, 'hard',
   'Udo Lattek holds the record for the most Bundesliga wins as a manager, having coached Bayern Munich, Borussia Mönchengladbach, and Borussia Dortmund across several successful spells from the late 1960s to the 1990s.'),

  (v_league, v_mg, 'Oliver Glasner won the Europa League with Eintracht Frankfurt. Which club did he manage next?',
   '["Wolfsburg","Crystal Palace","VfL Bochum","Hertha BSC"]', 1, 'medium',
   'Oliver Glasner joined Crystal Palace in England in February 2024 after leaving Eintracht Frankfurt, and helped them survive Premier League relegation before a new project in south London began.');

  -- ============================================================
  -- TRANSFERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_tr, 'Erling Haaland left Borussia Dortmund for Manchester City in 2022. What was the fee?',
   '["£45m","£51m","£60m","£75m"]', 1, 'medium',
   'Erling Haaland joined Manchester City from Borussia Dortmund for £51 million in June 2022 — significantly below his market value, due to a release clause in his contract negotiated when he signed in 2020.'),

  (v_league, v_tr, 'Robert Lewandowski joined Barcelona from Bayern Munich in 2022. What was the fee?',
   '["€45m","€50m","€55m","€65m"]', 0, 'medium',
   'Robert Lewandowski joined FC Barcelona for €45 million in July 2022, aged 33. Despite concerns about his age, he immediately won the La Liga Pichichi in his debut season.'),

  (v_league, v_tr, 'Jude Bellingham joined Real Madrid from Borussia Dortmund in 2023. What was the fee?',
   '["€95m","€103m","€115m","€150m"]', 1, 'medium',
   'Jude Bellingham joined Real Madrid from Borussia Dortmund for €103 million in June 2023, aged 19. He immediately became one of the world''s best players, scoring 23 goals in his debut LaLiga season.'),

  (v_league, v_tr, 'Leroy Sané moved from Manchester City back to Germany at Bayern Munich in 2020 for how much?',
   '["€40m","€45m","€49m","€55m"]', 1, 'medium',
   'Leroy Sané joined Bayern Munich from Manchester City for €45 million in July 2020, returning to the Bundesliga after four years in England. He had previously come through Schalke 04''s academy.'),

  (v_league, v_tr, 'Toni Kroos joined Real Madrid from Bayern Munich in 2014. What was the fee?',
   '["€18m","€21m","€25m","€30m"]', 2, 'medium',
   'Toni Kroos joined Real Madrid for approximately €25 million in July 2014, shortly after helping Germany win the World Cup. The fee was later seen as an extraordinary bargain given his performances for Madrid.'),

  (v_league, v_tr, 'The Bundesliga benefited from implementing a strict financial fair play system. What is the German equivalent called?',
   '["Das Lizenzierungssystem","Der Spielordnung","Die DFB-Kontrolle","Das Gleichgewichtsgesetz"]', 0, 'hard',
   'The DFL (Deutsche Fußball Liga) operates a strict club licensing system ("Lizenzierungsordnung") that prevents clubs from overspending, contributing to the financial stability of German football.'),

  (v_league, v_tr, 'Matthijs de Ligt moved from Juventus to Bayern Munich in 2022. How much did Bayern pay?',
   '["€50m","€60m","€67m","€75m"]', 2, 'medium',
   'Matthijs de Ligt joined Bayern Munich from Juventus for €67 million in July 2022. Despite initial promise, he moved to Manchester United in 2024 as Bayern pursued other defensive options.'),

  (v_league, v_tr, 'Sadio Mané left Liverpool to join Bayern Munich in 2022 for how much?',
   '["€32m","€38m","€41m","€45m"]', 2, 'medium',
   'Sadio Mané joined Bayern Munich from Liverpool for approximately €41 million in June 2022. Despite initial success, his time at Bayern was difficult and he left for Al-Nassr in 2023.'),

  (v_league, v_tr, 'Lucas Hernández joined Bayern Munich from Atlético de Madrid in 2019 for a then club record fee. How much?',
   '["€68m","€74m","€80m","€88m"]', 2, 'medium',
   'Lucas Hernández joined Bayern Munich from Atlético de Madrid for €80 million in 2019 — a then Bundesliga record transfer. Despite injuries, he became a key member of their 2019–20 Treble-winning squad.'),

  (v_league, v_tr, 'Which Bundesliga club sold Jadon Sancho to Manchester United in 2021 for £73m?',
   '["Bayern Munich","RB Leipzig","Schalke 04","Borussia Dortmund"]', 3, 'easy',
   'Jadon Sancho moved from Borussia Dortmund to Manchester United for £73 million in July 2021, after a year-long saga during which Dortmund held out for their asking price. Sancho had joined BVB from Manchester City in 2017.'),

  (v_league, v_tr, 'Mario Götze moved from Borussia Dortmund to Bayern Munich in 2013. What controversy surrounded this move?',
   '["He moved on a free transfer","The transfer was announced while Klopp was still manager","It happened during the Champions League Final season","All of the above"]', 2, 'hard',
   'Mario Götze''s move to Bayern Munich was announced in April 2013 — during the Champions League semi-final season at Borussia Dortmund. It caused enormous controversy as Klopp still had to manage Götze in the Champions League Final against Bayern.'),

  (v_league, v_tr, 'Harry Kane joined Bayern Munich from Tottenham Hotspur in 2023 for how much?',
   '["€80m","€90m","€100m","€110m"]', 2, 'medium',
   'Harry Kane joined Bayern Munich from Tottenham Hotspur for approximately €100 million in August 2023, making him one of the most expensive transfers in Bundesliga history. He immediately broke the club''s scoring records.'),

  (v_league, v_tr, 'Philipp Lahm spent his entire professional career at Bayern Munich. What age did he retire?',
   '["33","34","36","38"]', 0, 'medium',
   'Philipp Lahm retired from football in 2017 at age 33, turning down lucrative offers to continue playing. He became Bayern Munich''s sporting director before stepping down in 2019. He was also the 2014 World Cup captain.'),

  (v_league, v_tr, 'Kevin De Bruyne had a standout 2014–15 season at Wolfsburg before leaving. Which club signed him for approximately €54m?',
   '["Arsenal","Barcelona","Manchester City","Chelsea"]', 2, 'medium',
   'Kevin De Bruyne joined Manchester City from VfL Wolfsburg for approximately €54 million in August 2015, after an outstanding Bundesliga season where he scored 10 goals and provided 21 assists. He had previously been at Chelsea but was rarely used there.'),

  (v_league, v_tr, 'Bayern Munich signed Kingsley Coman from Juventus for how much in 2020?',
   '["€21m","€27m","€33m","€42m"]', 1, 'hard',
   'Kingsley Coman joined Bayern Munich permanently from Juventus for approximately €27 million in 2017 (after a loan period). He scored the winning goal in the 2020 Champions League Final against PSG.'),

  (v_league, v_tr, 'Uli Hoeneß famously laundered money through which illegal activity, leading to his resignation as Bayern president in 2014?',
   '["Bribery","Tax evasion","Match fixing","Money laundering from transfers"]', 1, 'hard',
   'Uli Hoeneß, Bayern Munich''s president and honorary president, was convicted of tax evasion in 2014 and sentenced to 3.5 years in prison. He had hidden approximately €27 million in a Swiss bank account. He was later released early and returned as honorary president.'),

  (v_league, v_tr, 'Serge Gnabry moved from Arsenal to which Bundesliga club before joining Bayern Munich?',
   '["Schalke","Hoffenheim","Werder Bremen","Wolfsburg"]', 2, 'medium',
   'Serge Gnabry left Arsenal for Werder Bremen in 2016 on loan and then permanently. He later joined TSG Hoffenheim before Bayern Munich signed him in 2017. He scored a famous four goals at Tottenham in the Champions League in 2019.'),

  (v_league, v_tr, 'Borussia Dortmund bought Erling Haaland for how much in January 2020?',
   '["€15m","€20m","€25m","€30m"]', 1, 'medium',
   'Erling Haaland joined Borussia Dortmund from RB Salzburg for approximately €20 million in January 2020 — an extraordinary fee for a player who went on to be worth €150-200 million by 2022.'),

  (v_league, v_tr, 'Jadon Sancho joined Borussia Dortmund in 2017 from which club for just €8 million?',
   '["Manchester United","Arsenal","Manchester City","Chelsea"]', 2, 'easy',
   'Jadon Sancho joined Borussia Dortmund from Manchester City in 2017 for approximately €8 million — one of the best value signings in Bundesliga history. He developed into one of Europe''s most exciting wingers, scoring 50 goals and providing 64 assists before Manchester United paid £73m for him in 2021.'),

  (v_league, v_tr, 'Which coach-turned-director helped orchestrate Bayern Munich''s dominance through smart transfer business?',
   '["Ottmar Hitzfeld","Uli Hoeneß","Hasan Salihamidžić","Karl-Heinz Rummenigge"]', 2, 'hard',
   'Hasan Salihamidžić served as Bayern Munich''s sporting director from 2017 to 2023, overseeing key transfers including Lucas Hernández, Leroy Sané, and numerous Champions League-quality signings.'),

  (v_league, v_tr, 'Dortmund sold Ousmane Dembélé to Barcelona in 2017 for approximately how much?',
   '["€60m","€75m","€96.8m","€105m"]', 2, 'medium',
   'Ousmane Dembélé joined FC Barcelona from Borussia Dortmund for €96.8 million in August 2017, following Neymar''s departure to PSG. Barcelona used part of Neymar''s world record €222 million fee to sign Dembélé.'),

  (v_league, v_tr, 'Granit Xhaka left which Bundesliga club to join Arsenal in 2016?',
   '["Schalke 04","Hamburger SV","Bayer Leverkusen","Borussia Mönchengladbach"]', 3, 'medium',
   'Granit Xhaka joined Arsenal from Borussia Mönchengladbach for approximately £34 million in June 2016. He spent seven years at Arsenal before joining Bayer Leverkusen in 2023, where he helped them win the Bundesliga.'),

  (v_league, v_tr, 'Ilkay Gündogan left Borussia Dortmund for Manchester City in 2016. Did he return to Germany?',
   '["Yes — to Bayern Munich","Yes — to Borussia Dortmund","Yes — to Bayer Leverkusen","No — he went to Barcelona"]', 3, 'hard',
   'İlkay Gündogan joined FC Barcelona from Manchester City in 2023 after his contract expired. He had a difficult season at Barça before leaving. He never returned to the Bundesliga as of 2024.'),

  (v_league, v_tr, 'Bayern Munich signed Joshua Kimmich from which club in 2015?',
   '["Schalke 04","Hamburger SV","RB Leipzig","VfB Stuttgart"]', 3, 'hard',
   'Joshua Kimmich joined Bayern Munich from VfB Stuttgart for approximately €8.5 million in 2015. He became one of the world''s best midfielders (and was originally a right-back), winning multiple Bundesliga titles and the Champions League.'),

  (v_league, v_tr, 'Which Bundesliga club successfully developed and retained Bojan Krkić during a loan spell?',
   '["Bayern Munich","Mainz 05","Hannover 96","1. FC Nürnberg"]', 1, 'hard',
   'Bojan Krkić had a loan spell at Mainz 05 in the 2012–13 season, where he impressed. However, he was owned by Barcelona and was not a permanent signing for Mainz. This question tests knowledge of specific loan arrangements.'),

  (v_league, v_tr, 'Benjamin Pavard joined Bayern Munich from which club in 2019?',
   '["Lyon","Marseille","VfB Stuttgart","Nice"]', 2, 'medium',
   'Benjamin Pavard joined Bayern Munich from VfB Stuttgart for approximately €35 million in 2019. He had impressed at the 2018 World Cup for France, scoring a stunning volley against Argentina. He later joined Inter Milan in 2023.'),

  (v_league, v_tr, 'Dortmund''s model of signing players cheaply and selling at profit is exemplified by which transfer from Ajax?',
   '["Christian Pulisic","Jadon Sancho","Jude Bellingham","Sébastien Haller"]', 3, 'hard',
   'Sébastien Haller joined Borussia Dortmund from Ajax for €31 million in 2023 after being diagnosed with testicular cancer mid-transfer saga. His return to form and scoring exploits were one of football''s most heartwarming stories.'),

  (v_league, v_tr, 'Which player''s move from Bayern Munich to Barcelona under the "free agent" status caused significant controversy?',
   '["Toni Kroos","Robert Lewandowski","David Alaba","Serge Gnabry"]', 2, 'medium',
   'David Alaba left Bayern Munich on a free transfer in 2021 after contract negotiations broke down. He joined Real Madrid, where he has become a key centre-back and helped them win multiple La Liga titles and Champions Leagues.');

  -- ============================================================
  -- STADIUM & CULTURE (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_sc, 'What is the official name of the Dortmund "Yellow Wall" terrace?',
   '["Gelbe Wand","Westfalenwall","Südtribüne","BVB Kurve"]', 2, 'medium',
   'The famous standing terrace at Signal Iduna Park is officially called the "Südtribüne" (South Stand). "Gelbe Wand" (Yellow Wall) is the nickname given by fans and media, reflecting the sea of yellow created by the 25,000 standing supporters.'),

  (v_league, v_sc, 'Bayern Munich''s anthem starts with which famous phrase?',
   '["Stern des Südens (Star of the South)","Mia san Mia","Rot und Weiß","Allianz Arena"]', 0, 'medium',
   '"Stern des Südens" (Star of the South) is Bayern Munich''s official club song and anthem. It reflects their status as the dominant club in southern Germany and their pride in their Bavarian identity.'),

  (v_league, v_sc, 'The Allianz Arena can change its exterior colour to represent which clubs?',
   '["Only Red (Bayern) and White (Germany)","Red (Bayern), Blue (1860 Munich), and White (Germany)","Red (Bayern) and Black (Dortmund)","Any colour requested"]', 1, 'medium',
   'The Allianz Arena''s distinctive inflatable exterior (ETFE plastic) can be lit in red (FC Bayern Munich), blue (TSV 1860 Munich, though they no longer use the stadium), or white (Germany national team matches).'),

  (v_league, v_sc, 'What makes Bundesliga standing sections unique compared to Premier League matches?',
   '["They are allowed and very popular, holding thousands of fans","They are banned for safety reasons","They are only permitted for away fans","They are enclosed areas for VIP members"]', 0, 'easy',
   'Standing sections (Stehplätze) are legal in the Bundesliga and are among the most popular parts of German stadiums. Signal Iduna Park''s Südtribüne holds 25,000 standing fans — the largest in European football.'),

  (v_league, v_sc, 'German football''s "50+1 rule" is designed to protect what aspect of the game?',
   '["Equal competition between clubs","Fan ownership and community connection","Foreign player limits","TV rights distribution"]', 1, 'easy',
   'The 50+1 rule ensures that registered club members (fans) must own more than 50% of voting rights in any club, preventing wealthy foreign investors from taking controlling interest and pricing out traditional supporters.'),

  (v_league, v_sc, 'What colour do Bayern Munich traditionally wear at home?',
   '["Red and white","All red","Red with blue trim","Black and red"]', 0, 'easy',
   'Bayern Munich wear a red and white home kit — predominantly red shirts with white shorts. The colours are a direct reference to their Bavarian identity, as red and white are the colours of the Free State of Bavaria.'),

  (v_league, v_sc, 'What is the Bundesliga''s founding year, and how does this compare to England''s Football League?',
   '["1963 — 75 years after England","1963 — 50 years after England","1963 — 85 years after England","1963 — 60 years after England"]', 0, 'hard',
   'The Bundesliga was founded in 1963, while England''s Football League began in 1888 — a difference of 75 years. Germany resisted a national professional league for decades, preferring regional amateur competitions.'),

  (v_league, v_sc, 'What is the name given to the fan culture of "ultras" support in German football?',
   '["Fanatics","Ultras","Supporters' Clubs","Fanblock"]', 1, 'easy',
   '"Ultras" groups exist throughout German football, maintaining highly organised, choreographed support with drums, flags, and tifo displays. Unlike England, German ultras groups often have political affiliations and take strong stances on football governance.'),

  (v_league, v_sc, 'The Bundesliga''s TV rights are sold in which way, and how does this affect smaller clubs?',
   '["Top clubs get most money; small clubs get little","TV money is distributed more equally than in the Premier League","Equal split between all clubs","Clubs sell their own rights"]', 1, 'medium',
   'The Bundesliga distributes TV money more equitably than many European leagues — smaller clubs receive a higher percentage relative to top clubs compared to the Premier League''s distribution model, helping competitive balance.'),

  (v_league, v_sc, 'Schalke 04''s traditional colours are which?',
   '["Red and white","Blue and white","Royal blue and white","Yellow and blue"]', 2, 'easy',
   'Schalke 04''s traditional colours are royal blue and white ("Königsblau und Weiß"). The specific shade of blue is distinctive and deeply associated with the Ruhr mining community that founded the club.'),

  (v_league, v_sc, 'What is the rivalry between Hamburg and Werder Bremen called?',
   '["Nordderby","Nordklassiker","Küstenderby","Der Norden"]', 0, 'medium',
   'The fixture between Hamburger SV and Werder Bremen is called the "Nordderby" (North Derby), reflecting the two clubs'' geographic proximity in northern Germany. It is one of the Bundesliga''s oldest and most passionate local rivalries.'),

  (v_league, v_sc, 'The Westfalenstadion (Signal Iduna Park) was built for which major event?',
   '["1974 World Cup","1988 European Championship","2006 World Cup","2002 World Cup"]', 0, 'medium',
   'Signal Iduna Park (then Westfalenstadion) was originally built for the 1974 FIFA World Cup hosted in West Germany. It opened in April 1974 and hosted five matches including the third-place playoff.'),

  (v_league, v_sc, 'What food is most associated with Bundesliga matchday culture?',
   '["Bratwurst (grilled sausage)","Currywurst","Pretzels","All three equally"]', 3, 'easy',
   'Bratwurst, Currywurst, and pretzels are all iconic German matchday foods. The Bundesliga is famous for its affordable food and drink inside stadiums — beer is available at Bundesliga grounds, unlike some European leagues.'),

  (v_league, v_sc, 'Borussia Dortmund''s famous yellow and black colours are said to represent which aspect of the club''s history?',
   '["The Prussian flag","The local Dortmund mining industry colours","The colours chosen at the club''s 1909 founding","No specific historical reason — they were randomly chosen"]', 2, 'medium',
   'Borussia Dortmund adopted black and yellow as their colours at the club''s founding in 1909, inspired by the colours of a local sports competition. The colours represent Dortmund''s identity and have become one of world football''s most recognisable strips.'),

  (v_league, v_sc, 'German football fans are known for the "Pyroshow" (flares and smoke bombs). Are these legal in German stadiums?',
   '["Yes — officially permitted","No — officially banned but widely tolerated","Yes — only in certain stadiums","No — severely punished always"]', 1, 'hard',
   'Pyrotechnics are officially banned in German stadiums, but they remain a contentious issue. Ultra groups continue to use flares despite bans, leading to stadium closures, fan sector closures, and ongoing negotiations between the DFL and fan groups.'),

  (v_league, v_sc, 'The Revierderby between Dortmund and Schalke is played in the "Revier" — what does "Revier" mean?',
   '["River","Region/mining district","Town","District boundary"]', 1, 'medium',
   '"Revier" in German originally meant a hunting or mining district. In this context it refers to the Ruhr industrial region — Germany''s old coal and steel heartland — where both Borussia Dortmund (Dortmund) and Schalke 04 (Gelsenkirchen) are located.'),

  (v_league, v_sc, 'The Olympiastadion in Berlin hosts which major German football event every year?',
   '["The Bundesliga Final","The DFB-Pokal Final","The German Super Cup","The Champions League Final"]', 1, 'easy',
   'The Olympiastadion in Berlin has hosted the DFB-Pokal Final (German Cup Final) since 1985. The stadium was originally built for the 1936 Berlin Olympics and has a capacity of approximately 74,475.'),

  (v_league, v_sc, 'What is the Bundesliga''s official mascot or symbol?',
   '["The Meisterschale","The DFB-Pokal Trophy","The Golden Boot","A Bundesliga ball"]', 0, 'hard',
   'The "Meisterschale" (Master''s Bowl/Plate) is the trophy awarded to the Bundesliga champion — a distinctive silver salver rather than a traditional trophy. It has been awarded since 1904 (as the German championship trophy) and is one of football''s most recognisable trophies.'),

  (v_league, v_sc, 'When Bayer Leverkusen won the Bundesliga in 2023–24 without losing, what nickname did they earn?',
   '["Die Unbesiegbaren","Die Sieger","Neverkusen no more","Die Unbezwingbaren"]', 0, 'hard',
   'Bayer Leverkusen''s unbeaten 2023–24 Bundesliga season earned them the nickname "Die Unbesiegbaren" (The Undefeated) and finally put to rest the "Neverkusen" label that had followed the club for over 20 years.'),

  (v_league, v_sc, 'What is the English translation of "Bundesliga"?',
   '["National League","Federal League","German League","Premier League"]', 1, 'easy',
   '"Bundesliga" translates as "Federal League" — "Bundes" referring to the federal state of Germany, and "Liga" meaning league. The same "Bundes" prefix is used in "Bundesrat" (Federal Council) and "Bundesregierung" (Federal Government).'),

  (v_league, v_sc, 'Union Berlin''s stadium, the Alte Försterei, is famous for which unique tradition?',
   '["The oldest standing terrace in Germany","Candle-lit Christmas matches with 28,000 fans","Prohibition of away fans","Allowing dogs inside the stadium"]', 1, 'hard',
   'Union Berlin hold an annual traditional Weihnachtssingen (Christmas Carol singing) event at the Alte Försterei, where tens of thousands of fans gather to sing carols by candlelight — one of football''s most unique traditions.'),

  (v_league, v_sc, 'The Bundesliga introduced VAR (Video Assistant Referee) in which season?',
   '["2016–17","2017–18","2018–19","2019–20"]', 1, 'medium',
   'The Bundesliga was among the first major European leagues to introduce VAR, implementing it in the 2017–18 season. Germany''s systematic approach to technology adoption made the rollout relatively smooth compared to other leagues.'),

  (v_league, v_sc, 'Which Bundesliga city is home to three professional football clubs, including two in the top two divisions?',
   '["Hamburg","Cologne","Berlin","Frankfurt"]', 2, 'medium',
   'Berlin is home to multiple professional football clubs, most notably Union Berlin (Bundesliga) and Hertha BSC (alternating between Bundesliga and 2. Bundesliga), as well as several lower division clubs including BFC Dynamo and FC Berlin.'),

  (v_league, v_sc, 'The "Dauerkarteninhaber" (season ticket holders) at Bundesliga clubs represent what percentage of typical matchday attendance?',
   '["20%","40%","60%","80%"]', 3, 'hard',
   'At major Bundesliga clubs like Bayern Munich and Borussia Dortmund, season ticket holders make up approximately 80% of matchday attendance. Waiting lists for season tickets at clubs like Dortmund can stretch to decades.'),

  (v_league, v_sc, 'What is the Bundesliga''s nickname in the English-speaking world, reflecting its entertaining style?',
   '["The Beautiful League","The Fan-First League","The People''s Game","The Thriller League"]', 1, 'medium',
   'While not an official title, the Bundesliga is often marketed internationally as "The Fan-First League" — emphasising its affordable tickets, standing sections, fan-friendly atmosphere, and community ownership structures.'),

  (v_league, v_sc, 'Bayern Munich''s 23-time German champion Uli Hoeneß is known as what in Munich?',
   '["The Kaiser","The Patriarch","The Red Baron","The Bayern God"]', 1, 'medium',
   'Uli Hoeneß is often called "The Patriarch" of Bayern Munich — the dominant figure who shaped the club''s modern identity as both sporting director and president across five decades, despite serving a prison term for tax evasion.');

end;
$$;
