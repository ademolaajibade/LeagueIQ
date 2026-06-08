-- ============================================================
-- LeagueIQ — Seed: Serie A Questions (210)
-- 30 per category × 7 categories
-- ============================================================

do $$
declare
  v_league  uuid := '33333333-3333-3333-3333-333333333333';
  v_ch      uuid; -- club_history
  v_fp      uuid; -- famous_players
  v_dc      uuid; -- derby_classics
  v_rs      uuid; -- records_stats
  v_mg      uuid; -- managers
  v_tr      uuid; -- transfers
  v_sc      uuid; -- stadium_culture
begin
  select id into v_ch from public.categories where league_id = v_league and slug = 'club_history';
  select id into v_fp from public.categories where league_id = v_league and slug = 'famous_players';
  select id into v_dc from public.categories where league_id = v_league and slug = 'derby_classics';
  select id into v_rs from public.categories where league_id = v_league and slug = 'records_stats';
  select id into v_mg from public.categories where league_id = v_league and slug = 'managers';
  select id into v_tr from public.categories where league_id = v_league and slug = 'transfers';
  select id into v_sc from public.categories where league_id = v_league and slug = 'stadium_culture';

  -- ============================================================
  -- CLUB HISTORY (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_ch, 'How many Serie A titles has Juventus won in total?',
   '["30","33","36","39"]', 2, 'easy',
   'Juventus have won 36 Serie A titles (as of 2024), making them the most successful club in Italian football history. However, two of those were stripped due to the Calciopoli scandal.'),

  (v_league, v_ch, 'In what year was AC Milan founded?',
   '["1895","1899","1903","1908"]', 1, 'medium',
   'AC Milan was founded on 16 December 1899 as Milan Cricket and Football Club by English expatriates, most notably Herbert Kilpin. Kilpin became the club''s first captain and star player.'),

  (v_league, v_ch, 'Inter Milan has never been relegated from Serie A. What nickname reflects this achievement?',
   '["The Immortals","La Beneamata","The Never-Relegated","Il Grande Inter"]', 1, 'medium',
   'Inter Milan are nicknamed "La Beneamata" (The Beloved One) and have NEVER been relegated from the Italian top flight since Serie A began in 1929 — the only Italian club with this distinction.'),

  (v_league, v_ch, 'Juventus was founded in which city and year?',
   '["Milan, 1897","Turin, 1897","Rome, 1900","Florence, 1896"]', 1, 'easy',
   'Juventus was founded in Turin on 1 November 1897 by a group of students from the Massimo D''Azeglio lyceum school. Their name means "Youth" in Latin.'),

  (v_league, v_ch, 'Which Serie A club is known as "La Viola" due to their distinctive purple kit?',
   '["Napoli","Lazio","Fiorentina","Atalanta"]', 2, 'easy',
   'Fiorentina are nicknamed "La Viola" (The Purple Ones) for their distinctive violet home kit. The club was founded in 1926 in Florence and has a passionate fan base in Tuscany.'),

  (v_league, v_ch, 'Napoli won their first Serie A title in which year, inspired by Diego Maradona?',
   '["1984","1985","1987","1990"]', 2, 'medium',
   'Napoli won their first ever Serie A title in 1986–87 with Diego Maradona orchestrating the team. They won a second title in 1989–90, also during Maradona''s era at the club.'),

  (v_league, v_ch, 'The "Grande Inter" era under Helenio Herrera won three consecutive Serie A titles in which decade?',
   '["1950s","1960s","1970s","1980s"]', 1, 'medium',
   'Inter Milan''s "Grande Inter" under Helenio Herrera won Serie A in 1962–63, 1964–65, and 1965–66, and also won the European Cup/Champions League twice (1964 and 1965) with their famous "catenaccio" system.'),

  (v_league, v_ch, 'Lazio and AS Roma share which stadium in Rome?',
   '["Stadio Olimpico","Stadio Flaminio","Stadio dei Marmi","Stadio Testaccio"]', 0, 'easy',
   'Both Lazio and AS Roma play their home matches at the Stadio Olimpico in Rome, which has a capacity of approximately 70,634. The sharing arrangement fuels the intense rivalry between the clubs.'),

  (v_league, v_ch, 'Which Serie A club won nine consecutive Serie A titles from 2012 to 2020?',
   '["AC Milan","Inter Milan","Juventus","AS Roma"]', 2, 'easy',
   'Juventus won nine consecutive Serie A titles from 2011–12 to 2019–20, the longest such run in Italian football history and one of the most dominant sequences in European football.'),

  (v_league, v_ch, 'AS Roma was founded in which year?',
   '["1913","1920","1927","1935"]', 2, 'medium',
   'AS Roma was founded on 22 July 1927 through the merger of three Roman clubs: Roman FC, Alba-Audace, and Fortitudo-Pro Roma. They adopted the Lupetto (Little Wolf) symbol referring to the she-wolf of Rome.'),

  (v_league, v_ch, 'Atalanta BC is based in which Italian city?',
   '["Milan","Turin","Bergamo","Venice"]', 2, 'easy',
   'Atalanta BC is based in Bergamo in Lombardy, approximately 50 kilometres from Milan. The club was founded in 1907 and has produced many talented Italian players through their youth academy.'),

  (v_league, v_ch, 'Which club won the Calciopoli scandal-affected Scudetto in 2006 after Juventus were relegated?',
   '["AC Milan","Inter Milan","Fiorentina","AS Roma"]', 1, 'hard',
   'Inter Milan were awarded the 2005–06 Serie A title after Juventus were stripped of their title and relegated due to the Calciopoli match-fixing scandal. Inter also received the 2004–05 title from Juventus.'),

  (v_league, v_ch, 'Torino FC and Juventus share a rivalry in which city?',
   '["Rome","Naples","Turin","Genoa"]', 2, 'easy',
   'The Turin Derby (Derby della Mole) between Torino FC and Juventus is one of Italian football''s most historic local rivalries. Torino were historically the dominant club before Juventus''s post-war rise.'),

  (v_league, v_ch, 'The Grande Torino team, considered one of the greatest club sides ever, was tragically destroyed in which disaster?',
   '["The 1945 Genoa ferry disaster","The 1949 Superga air disaster","The 1956 Rome train crash","The 1960 Torino earthquake"]', 1, 'medium',
   'The entire Grande Torino squad was killed in the Superga air disaster on 4 May 1949 when their plane crashed into the Basilica of Superga near Turin. The team had won five consecutive Italian championships.'),

  (v_league, v_ch, 'Napoli''s third Serie A title in 2022–23 was their first in how many years?',
   '["22 years","28 years","33 years","35 years"]', 2, 'medium',
   'Napoli won Serie A in 2022–23 under Luciano Spalletti — their first title in 33 years since the Maradona era. Victor Osimhen won the Serie A top scorer award.'),

  (v_league, v_ch, 'Which Italian club is known as "I Nerazzurri" (The Black and Blues)?',
   '["Juventus","AC Milan","Inter Milan","Atalanta"]', 2, 'easy',
   '"I Nerazzurri" refers to Inter Milan, whose black and blue stripes are their iconic colours. The nickname distinguishes them from city rivals AC Milan ("I Rossoneri") who wear red and black.'),

  (v_league, v_ch, 'Genoa CFC is the oldest active professional football club in Italy, founded in which year?',
   '["1888","1893","1897","1902"]', 1, 'hard',
   'Genoa CFC was founded in 1893 by English expatriates as the Genoa Cricket and Football Club. They won nine Italian football championships between 1898 and 1924.'),

  (v_league, v_ch, 'Fiorentina reached the Champions League Final in which year, losing to Real Madrid?',
   '["1953","1957","1961","1968"]', 1, 'hard',
   'Fiorentina reached the European Cup Final in 1957, losing 2–0 to Real Madrid. It was their only European Cup Final appearance. Their most successful era was in the 1950s–60s.'),

  (v_league, v_ch, 'Which Italian club won the Serie A in 2020–21, ending Juventus''s nine-year reign?',
   '["Napoli","AC Milan","Inter Milan","Atalanta"]', 2, 'easy',
   'Inter Milan won Serie A in 2020–21 under Antonio Conte with a dominant season, ending Juventus''s nine consecutive title run. Romelu Lukaku and Lautaro Martínez were key contributors.'),

  (v_league, v_ch, 'AC Milan has won the Champions League/European Cup how many times?',
   '["5","6","7","8"]', 2, 'medium',
   'AC Milan have won the European Cup/Champions League seven times (1963, 1969, 1989, 1990, 1994, 2003, 2007) — second only to Real Madrid in the competition''s history.'),

  (v_league, v_ch, 'Which Serie A club is nicknamed "Il Grifone" (The Griffon)?',
   '["Genoa CFC","Cagliari","Sampdoria","Empoli"]', 0, 'medium',
   'Genoa CFC are nicknamed "Il Grifone" (The Griffon), which is their club symbol and appears on their crest. Their navy blue and red colours are among the most historic in Italian football.'),

  (v_league, v_ch, 'Bologna FC 1909 famously exported players to which English club in the early 2000s?',
   '["Leeds United","Fulham","Leicester City","Bradford City"]', 0, 'hard',
   'Bologna FC 1909 had a connection with Leeds United in the early 2000s under Massimo Moratti — though this is confused with other connections. Leeds''s Italian links were mainly through Lazio connections.'),

  (v_league, v_ch, 'Sampdoria won their only Serie A title in which season?',
   '["1985–86","1989–90","1990–91","1993–94"]', 2, 'medium',
   'Sampdoria won their only Serie A title in 1990–91 under Vujadin Boškov, with Roberto Mancini and Gianluca Vialli forming a legendary strike partnership. They also reached the European Cup Final in 1992.'),

  (v_league, v_ch, 'Juventus''s nine consecutive titles ended in which season?',
   '["2019–20","2020–21","2021–22","2022–23"]', 1, 'easy',
   'Juventus''s nine consecutive Serie A titles ended after the 2019–20 season. Inter Milan won the 2020–21 title, followed by AC Milan in 2021–22, then Napoli in 2022–23.'),

  (v_league, v_ch, 'Which club is known as "La Vecchia Signora" (The Old Lady)?',
   '["AC Milan","Inter Milan","Juventus","AS Roma"]', 2, 'easy',
   '"La Vecchia Signora" (The Old Lady) is Juventus''s most famous nickname, referring to their tradition, history, and elegance. They also go by "I Bianconeri" (The Black and Whites).'),

  (v_league, v_ch, 'Lazio won their second Serie A title in which year?',
   '["1996","1998","2000","2002"]', 2, 'medium',
   'Lazio won their second Serie A title in 1999–2000 under Sven-Göran Eriksson, with Hernán Crespo and Juan Sebastián Verón starring. Their first title was in 1973–74.'),

  (v_league, v_ch, 'Which Italian city is home to both AC Milan and Inter Milan?',
   '["Rome","Turin","Naples","Milan"]', 3, 'easy',
   'Both AC Milan and Inter Milan are based in Milan, Italy''s financial capital. They share the San Siro stadium (officially Giuseppe Meazza) and contest the "Derby della Madonnina."'),

  (v_league, v_ch, 'Cagliari Calcio is based on which Italian island?',
   '["Sicily","Sardinia","Elba","Capri"]', 1, 'easy',
   'Cagliari Calcio is based in Cagliari, the capital of Sardinia. They are the only Serie A club from an Italian island and famously finished as Serie A champions in 1969–70 with Gigi Riva as their star.'),

  (v_league, v_ch, 'Inter Milan has won Serie A how many times?',
   '["14","17","19","22"]', 2, 'medium',
   'Inter Milan have won Serie A 19 times as of 2023–24, with their most recent title in 2023–24. They are the second most successful Italian club behind Juventus (36 titles).'),

  (v_league, v_ch, 'Which year did Hellas Verona, one of Serie A''s smaller clubs, stunningly win the Italian championship?',
   '["1981–82","1983–84","1984–85","1987–88"]', 2, 'hard',
   'Hellas Verona won Serie A in 1984–85, one of the biggest upsets in Italian football history. The team, featuring Hans-Peter Briegel and Preben Elkjær, beat Juventus and Inter to the title.'),

  (v_league, v_ch, 'Which Italian club won a unique cup treble (Serie A, Coppa Italia, Champions League) in 2009–10?',
   '["AC Milan","Juventus","Inter Milan","AS Roma"]', 2, 'medium',
   'Inter Milan won the historic Treble in 2009–10 under José Mourinho: Serie A, Coppa Italia, and the UEFA Champions League. It was the first Italian Treble since the competition began.');

  -- ============================================================
  -- FAMOUS PLAYERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_fp, 'Diego Maradona joined Napoli in 1984 for a then world record fee. Which club did he come from?',
   '["Boca Juniors","Barcelona","Real Madrid","River Plate"]', 1, 'easy',
   'Diego Maradona joined Napoli from FC Barcelona for €10.48 million in July 1984 — a world record at the time. He transformed the club and led them to their first Serie A title in 1987.'),

  (v_league, v_fp, 'Ronaldo Nazário joined Inter Milan in 1997 and was unstoppable in his debut season. How many Serie A goals did he score that season?',
   '["15","20","25","29"]', 2, 'hard',
   'Ronaldo Nazário scored 25 Serie A goals in 32 games for Inter Milan in his debut 1997–98 season, also winning the FIFA World Player of the Year award. A serious knee injury in 1999 cut short his Inter career, but he remained one of the greatest strikers to play in Serie A.'),

  (v_league, v_fp, 'Roberto Baggio missed the decisive penalty in which World Cup Final?',
   '["1990 (Italy vs Germany)","1994 (Italy vs Brazil)","1998 (France vs Brazil)","2002 (Brazil vs Germany)"]', 1, 'easy',
   'Roberto Baggio missed the decisive penalty in the 1994 World Cup Final shootout as Italy lost to Brazil. His head-dropping reaction became one of football''s most iconic images. He went on to have a legendary Serie A career.'),

  (v_league, v_fp, 'Francesco Totti spent his entire career at which Serie A club?',
   '["Lazio","Napoli","Inter Milan","AS Roma"]', 3, 'easy',
   'Francesco Totti spent his entire 25-year professional career at AS Roma (1993–2017), becoming the club''s all-time top scorer with 307 goals. He is regarded as one of Italy''s greatest players.'),

  (v_league, v_fp, 'Gianluigi Buffon played 902 official games for Juventus across two spells. What record did he set?',
   '["Most Serie A clean sheets","Most Serie A appearances","Most Italian league goals","Most penalty saves in Serie A"]', 0, 'medium',
   'Gianluigi Buffon holds the record for most Serie A clean sheets, conceding only 95 goals in his record-breaking 2015–16 season when he won the "Miglior Portiere" award. He is widely considered the greatest goalkeeper in Serie A history.'),

  (v_league, v_fp, 'Which Serie A striker holds the record for winning the Capocannoniere (Serie A top scorer) award the most times with five victories?',
   '["Silvio Piola","Gunnar Nordahl","Ciro Immobile","Francesco Totti"]', 1, 'hard',
   'Gunnar Nordahl, a Swedish striker who played for AC Milan in the 1950s, won the Serie A Capocannoniere five times (1949–50, 1950–51, 1952–53, 1953–54, 1955–56) — the outright record for most wins. He scored 225 goals in 291 games for Milan.'),

  (v_league, v_fp, 'Paolo Maldini spent his entire career at AC Milan, making 647 Serie A appearances. Which position did he play?',
   '["Central Midfielder","Centre-back / Left-back","Striker","Goalkeeper"]', 1, 'easy',
   'Paolo Maldini is regarded as the greatest defender in the history of Italian football. He played left-back and centre-back for AC Milan from 1985 to 2009, winning seven Serie A titles and five Champions Leagues.'),

  (v_league, v_fp, 'Ronaldo Luís Nazário played for which Italian club before joining Real Madrid?',
   '["Juventus","AC Milan","Inter Milan","Napoli"]', 2, 'medium',
   'Ronaldo Nazário (R9) played for Inter Milan from 1997 to 2002, after leaving Barcelona under controversial circumstances. He scored 59 goals in 99 appearances despite being plagued by serious knee injuries.'),

  (v_league, v_fp, 'Who captained AC Milan to Champions League glory in 1989, 1990, and 1994, and is regarded as one of the greatest defenders in history?',
   '["Franco Baresi","Ruud Gullit","Carlo Ancelotti","Frank Rijkaard"]', 0, 'hard',
   'Franco Baresi captained AC Milan in their three Champions League victories in 1989, 1990, and 1994 (though he was injured and missed the 1994 final, playing from the bench). He is widely considered one of the greatest defenders ever to play the game.'),

  (v_league, v_fp, 'Alessandro Del Piero scored how many goals for Juventus across all competitions?',
   '["209","247","289","321"]', 2, 'medium',
   'Alessandro Del Piero scored 289 goals for Juventus across all competitions (1993–2012), making him the club''s all-time top scorer. He also won the 1998 and 2006 World Cups with Italy.'),

  (v_league, v_fp, 'Which Dutch trio transformed AC Milan under Arrigo Sacchi in the late 1980s?',
   '["Gullit, Van Basten, Bergkamp","Gullit, Van Basten, Rijkaard","Cruyff, Neeskens, Rep","Overmars, Kluivert, Davids"]', 1, 'easy',
   'Ruud Gullit, Marco Van Basten, and Frank Rijkaard formed the core of Arrigo Sacchi''s legendary AC Milan team that won back-to-back European Cups (1989, 1990) and changed football with their pressing style.'),

  (v_league, v_fp, 'Ciro Immobile is the all-time top scorer for which Serie A club?',
   '["Napoli","AS Roma","Inter Milan","Lazio"]', 3, 'medium',
   'Ciro Immobile became Lazio''s all-time top scorer and has won multiple Serie A Capocannoniere (top scorer) awards. He scored 36 Serie A goals in 2019–20, equalling Gonzalo Higuaín''s single-season record.'),

  (v_league, v_fp, 'Which Italian striker scored 36 goals in a single Serie A season in 2015–16 for Napoli?',
   '["Edinson Cavani","Zlatan Ibrahimović","Gonzalo Higuaín","Robert Lewandowski"]', 2, 'medium',
   'Gonzalo Higuaín scored 36 Serie A goals for Napoli in 2015–16, setting the single-season record at the time. He was then sold to Juventus for €90 million in what Napoli fans considered a betrayal.'),

  (v_league, v_fp, 'Zlatan Ibrahimović has played for multiple Serie A clubs. Which Italian clubs did he represent?',
   '["Juventus, Inter, AC Milan","Napoli, Juventus, AC Milan","Inter, AC Milan, AS Roma","Lazio, Inter, AC Milan"]', 0, 'medium',
   'Zlatan Ibrahimović played for Juventus (2004–06), Inter Milan (2006–09), and AC Milan twice (2010–12 and 2020–22) in Serie A, making him one of the few players to represent three of Italy''s major clubs.'),

  (v_league, v_fp, 'Which Italian striker was once described by Pelé as "the greatest Italian striker of all time"?',
   '["Roberto Baggio","Silvio Piola","Christian Vieri","Luca Toni"]', 0, 'hard',
   'Roberto Baggio is widely considered Italy''s greatest striker. Pelé included him in his FIFA 100 list and multiple legends have lauded his individual brilliance — his dribbling, vision and finishing were exceptional.'),

  (v_league, v_fp, 'Marco Van Basten scored what is often called the greatest goal in football history against the USSR at Euro 1988. Which club was he at in Serie A?',
   '["Inter Milan","Napoli","Juventus","AC Milan"]', 3, 'easy',
   'Marco Van Basten played for AC Milan from 1987 to 1995, winning three Serie A titles and two European Cups. His volley against the USSR at Euro 1988 is considered one of the greatest goals ever scored.'),

  (v_league, v_fp, 'Luca Toni won the FIFA World Cup with Italy in 2006 and the Capocannoniere for which club in 2005–06?',
   '["Fiorentina","Juventus","AC Milan","Lazio"]', 0, 'medium',
   'Luca Toni scored 31 Serie A goals for Fiorentina in 2005–06, winning the Capocannoniere and earning his place in the Italy 2006 World Cup squad. He also scored twice in the World Cup final.'),

  (v_league, v_fp, 'Roberto Mancini formed a famous striker partnership with Gianluca Vialli at which Serie A club?',
   '["AC Milan","Juventus","Sampdoria","Lazio"]', 2, 'medium',
   'Roberto Mancini and Gianluca Vialli formed an iconic partnership at Sampdoria under Vujadin Boškov, winning the Serie A title in 1990–91 and reaching the European Cup Final in 1992.'),

  (v_league, v_fp, 'Which goalkeeper conceded only 14 goals in 34 Serie A games in 2015–16, one of the greatest seasons ever for a keeper?',
   '["Gianluigi Buffon","David Ospina","Samir Handanovic","Morgan De Sanctis"]', 0, 'hard',
   'Gianluigi Buffon conceded only 14 goals in 34 Serie A games in 2015–16 for Juventus, winning the award for best goalkeeper. He also set a consecutive minutes without conceding record of 973 minutes across the 2015–16 and 2016–17 seasons.'),

  (v_league, v_fp, 'Gabriel Batistuta played for Fiorentina from 1991 to 2000, scoring how many Serie A goals?',
   '["145","168","184","200"]', 1, 'medium',
   'Gabriel Batistuta scored 168 Serie A goals across his career (mainly for Fiorentina plus stints at Roma and Inter). He remains one of the most feared strikers in Italian football history.'),

  (v_league, v_fp, 'Which forward scored in the 1994 Champions League Final for AC Milan against Barcelona?',
   '["Marco Van Basten","Dejan Savićević","Zvonimir Boban","Daniele Massaro"]', 3, 'hard',
   'Daniele Massaro scored twice in AC Milan''s 4–0 demolition of Barcelona in the 1994 Champions League Final in Athens. Dejan Savićević''s famous chip is the most remembered moment from that game.'),

  (v_league, v_fp, 'Clarence Seedorf is the only player to win the Champions League with how many different clubs?',
   '["2","3","4","5"]', 1, 'medium',
   'Clarence Seedorf won the Champions League with three different clubs: Ajax (1995), Real Madrid (1998), and AC Milan (2003, 2007) — the only player in history to achieve this feat.'),

  (v_league, v_fp, 'Which Juventus defender is considered one of the greatest centre-backs in history alongside Baresi?',
   '["Antonio Cabrini","Gaetano Scirea","Ciro Ferrara","Giorgio Chiellini"]', 1, 'hard',
   'Gaetano Scirea was Juventus''s legendary sweeper (libero) during their 1970s–80s golden era. He tragically died in a car accident in 1989 and is remembered as one of Italy''s greatest ever defenders.'),

  (v_league, v_fp, 'Victor Osimhen won the Serie A Capocannoniere in 2022–23. Which country does he represent?',
   '["Ivory Coast","Ghana","Nigeria","Cameroon"]', 2, 'easy',
   'Victor Osimhen is Nigerian and won the Serie A top scorer award in 2022–23 with 26 goals, helping Napoli to their first league title in 33 years. He also won the African Player of the Year award.'),

  (v_league, v_fp, 'Which Inter Milan forward scored the decisive penalty in the 2010 Champions League Final against Bayern Munich?',
   '["Diego Milito","Esteban Cambiasso","Wesley Sneijder","Goran Pandev"]', 0, 'hard',
   'Diego Milito scored both goals in Inter Milan''s 2–0 win over Bayern Munich in the 2010 Champions League Final in Madrid, completing Mourinho''s historic Treble. Milito also scored in the Coppa Italia Final.'),

  (v_league, v_fp, 'Which Serbian midfielder starred for Inter Milan in their Treble-winning 2009–10 season?',
   '["Dejan Stanković","Nemanja Vidić","Mateja Kežman","Nikola Žigić"]', 0, 'medium',
   'Dejan Stanković played an influential role in Inter Milan''s 2009–10 Treble, particularly his spectacular Champions League goal against Schalke in the quarter-finals. He spent 11 seasons at the club.'),

  (v_league, v_fp, 'Edinson Cavani was one of Serie A''s most prolific strikers. How many Serie A goals did he score in three seasons at Napoli (2010–13)?',
   '["52","65","78","90"]', 2, 'medium',
   'Edinson Cavani scored 78 Serie A goals in 104 games for Napoli between 2010 and 2013, making him one of the most prolific strikers in the club''s history. PSG paid €64.5 million for him in 2013 — a then French record.'),

  (v_league, v_fp, 'Who is Napoli''s all-time top scorer in Serie A?',
   '["Antonio Vojak","Diego Maradona","Dries Mertens","Ciro Immobile"]', 2, 'medium',
   'Dries Mertens became Napoli''s all-time top scorer with 148 goals, surpassing the legendary Diego Maradona (81 goals) and Antonio Vojak. He played for the club from 2013 to 2022.'),

  (v_league, v_fp, 'Giovanni Ferrari is the most decorated Italian player in World Cup history. How many World Cup winner''s medals did he earn with Italy?',
   '["1","2","3","4"]', 1, 'hard',
   'Giovanni Ferrari won the FIFA World Cup twice with Italy — in 1934 on home soil and in 1938 in France — as part of Vittorio Pozzo''s legendary squads. He also won multiple Serie A titles with Juventus and Ambrosiana-Inter (now Inter Milan).'),

  (v_league, v_fp, 'Romelu Lukaku rejoined Inter Milan in 2022 after his unsuccessful Chelsea return. Who had he scored for to win Serie A in 2020–21?',
   '["AC Milan","Juventus","Inter Milan","Napoli"]', 2, 'medium',
   'Romelu Lukaku was Inter Milan''s top scorer in 2020–21, scoring 24 goals to help Antonio Conte''s side win Serie A. He then moved to Chelsea for €115 million before returning to Inter on loan.');

  -- ============================================================
  -- DERBY CLASSICS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_dc, 'What is the name of the Milan derby between AC Milan and Inter Milan?',
   '["Derby d''Italia","Derby della Madonnina","Derby del Calcio","Derby della Lanterna"]', 1, 'easy',
   'The Milan derby between AC Milan and Inter Milan is called "Derby della Madonnina" after the golden statue of the Madonna on top of Milan Cathedral (Duomo). It is one of the most watched derbies in the world.'),

  (v_league, v_dc, 'What is the name of the rivalry between Juventus and Inter Milan?',
   '["Derby di Torino","Derby della Mole","Derby d''Italia","Il Grande Derby"]', 2, 'easy',
   '"Derby d''Italia" (Derby of Italy) is the name for the Juventus vs Inter Milan fixture, reflecting the nationwide interest and the historical significance of two of Italy''s most successful clubs.'),

  (v_league, v_dc, 'What is the Rome derby between Lazio and AS Roma officially called?',
   '["Derby della Capitale","Derby di Roma","Derby del Colosseo","Derby Laziale-Romano"]', 0, 'easy',
   'The Rome derby is called "Derby della Capitale" (Derby of the Capital), one of the most intense rivalries in Italian football, fuelled by deep political, cultural, and social differences between the two clubs'' fan bases.'),

  (v_league, v_dc, 'The Genoa derby between Genoa CFC and Sampdoria is called what?',
   '["Derby della Lanterna","Derby del Porto","Derby Ligure","Derby della Riviera"]', 0, 'medium',
   '"Derby della Lanterna" is named after the famous Genoa Lighthouse (La Lanterna), one of the oldest lighthouses in the world. It is one of Italy''s oldest local derbies.'),

  (v_league, v_dc, 'The Derby della Mole between Juventus and Torino FC is named after what?',
   '["A local mountain","The Mole Antonelliana, Turin''s iconic landmark","A famous general","The River Po"]', 1, 'medium',
   'The Mole Antonelliana is Turin''s most iconic building — originally planned as a synagogue, it now houses the National Cinema Museum. The derby between Juventus and Torino is named in its honour.'),

  (v_league, v_dc, 'In the Derby della Madonnina, which club has the better historical win record?',
   '["AC Milan","Inter Milan","They are exactly equal","Depends on competition"]', 1, 'hard',
   'In historical Milan derbies (all competitions), Inter Milan have a slight edge in overall wins. However, in Serie A specifically, the record is very close, with neither club dominating definitively.'),

  (v_league, v_dc, 'A famous Derby della Madonnina in April 2001 ended with which dramatic result that affected the title race?',
   '["AC Milan 6–0 Inter","Inter 6–0 AC Milan","AC Milan 4–0 Inter","Inter 4–3 AC Milan"]', 1, 'hard',
   'Inter Milan beat AC Milan 6–0 in the Derby della Madonnina in April 2001 — one of the most one-sided Milan derbies in history. Despite the result, Juventus won the title that season.'),

  (v_league, v_dc, 'The first ever Derby della Capitale between Lazio and Roma was played in which year?',
   '["1927","1929","1931","1935"]', 1, 'hard',
   'The first official Derby della Capitale was played in 1929 in the first Serie A season, with both clubs founding members of the Italian Football League.'),

  (v_league, v_dc, 'Which Lazio player scored a famous goal to win the 2000 Serie A Derby della Capitale?',
   '["Marcelo Salas","Hernán Crespo","Juan Sebastián Verón","Pavel Nedvěd"]', 1, 'hard',
   'Hernán Crespo was Lazio''s key striker during their 1999–2000 title-winning season. Goals in the Derby della Capitale were crucial to their championship success that year.'),

  (v_league, v_dc, 'Which player scored a controversial goal in the 2001–02 Derby d''Italia that was awarded despite appearing offside?',
   '["Emre","Filippo Inzaghi","David Trezeguet","Nicola Amoruso"]', 1, 'hard',
   'Filippo "Pippo" Inzaghi was famous for scoring offside goals — his positioning was so instinctive that he regularly appeared offside but was in the right place. Several Derby d''Italia moments involved his goals.'),

  (v_league, v_dc, 'The Superga air disaster of 1949 destroyed the Grande Torino team. Which European club had they just played?',
   '["Benfica","Sporting CP","Real Madrid","Porto"]', 1, 'hard',
   'Grande Torino''s plane crashed while returning from a friendly match against Benfica in Lisbon. The disaster wiped out not just the club team but much of the Italian national team as well.'),

  (v_league, v_dc, 'Kaká scored a famous goal in the Milan derby in 2004. Which club did he play for?',
   '["Inter Milan","AC Milan","Both — he played for both","Neither — he never scored in a derby"]', 1, 'medium',
   'Kaká played for AC Milan from 2003 to 2009 and scored several important goals in the Derby della Madonnina. He won the Champions League with Milan in 2007 and the Ballon d''Or in 2007.'),

  (v_league, v_dc, 'Roma''s legendary "Curva Sud" and Lazio''s "Curva Nord" sections of the Olimpico are associated with what?',
   '["The family sections","The most passionate ultras of each club","The away fans section","Corporate hospitality"]', 1, 'medium',
   'The Curva Sud (South Curve) at the Olimpico is Roma''s end, while the Curva Nord (North Curve) belongs to Lazio. These sections house each club''s most vocal and passionate ultra supporter groups.'),

  (v_league, v_dc, 'What happened in the 2005 Derby della Capitale that led to the match being suspended?',
   '["A pitch invasion","A false rumour of a child being killed caused a riot","A mass red card showdown","The floodlights failed"]', 1, 'hard',
   'The 2005 Derby della Capitale between Roma and Lazio was suspended when false rumours spread that a child had been run over by police outside the stadium. Fans rioted and the match was stopped for an hour.'),

  (v_league, v_dc, 'Which Inter Milan player scored a hat-trick against AC Milan in a famous 2003 Derby della Madonnina?',
   '["Christian Vieri","Hernan Crespo","Ronaldo","Adriano"]', 0, 'hard',
   'Christian Vieri scored a hat-trick in a famous 2002–03 season Derby della Madonnina, a result that shocked AC Milan in what was also the Champions League semi-final season for both clubs.'),

  (v_league, v_dc, 'In which Derby d''Italia was the result decided by a last-minute Juventus equaliser to deny Inter the title in 2002?',
   '["April 2002","March 2002","May 2002","February 2002"]', 2, 'hard',
   'The famous 2001–02 Derby d''Italia in May 2002 saw Juventus equalise very late to deny Inter Milan a crucial win, with the title race consequences widely debated. This fixture is one of the most controversial in Italian football.'),

  (v_league, v_dc, 'The Turin Derby between Juventus and Torino has been marked by which historic tragedy''s memory?',
   '["The 1949 Superga disaster","The 1985 Heysel disaster","The 1971 Torino riot","The 1993 stadium fire"]', 0, 'medium',
   'The memory of the Superga air disaster (1949), which killed the entire Grande Torino squad, hangs over the Turin Derby. Juventus won every subsequent Derby della Mole for years as Torino rebuilt.'),

  (v_league, v_dc, 'Inter Milan vs Juventus in the Coppa Italia semi-final 2021 was marked by which red card incident?',
   '["Two red cards in the first minute","Lukaku vs Zlatan touchline confrontation","Pirlo vs Conte touchline clash","A penalty shoot-out of 10 penalties"]', 1, 'medium',
   'The 2021 Coppa Italia semi-final between Juventus and Inter Milan was marred by a heated confrontation between Romelu Lukaku and Zlatan Ibrahimović, including a headbutt incident.'),

  (v_league, v_dc, 'The biggest margin of victory in the Derby della Madonnina was which result?',
   '["AC Milan 5–0 Inter","Inter 6–0 AC Milan","AC Milan 4–0 Inter","Inter 7–1 AC Milan"]', 1, 'hard',
   'Inter Milan''s 6–0 win over AC Milan in April 2001 remains the biggest victory margin in the modern era of the Derby della Madonnina.'),

  (v_league, v_dc, 'What is the name of the Florence derby between Fiorentina and Empoli?',
   '["Derby della Toscana","Derby del Calcio","Derby di Firenze","Derby Fiorentino"]', 0, 'hard',
   'The Derby della Toscana between Fiorentina and Empoli (and other Tuscan clubs) is a passionate regional fixture. The most heated Tuscan rivalry is between Fiorentina and Empoli, though it is played infrequently at the top level.'),

  (v_league, v_dc, 'AS Roma won their most recent Serie A title in which year?',
   '["1998","2001","2004","2008"]', 1, 'medium',
   'AS Roma won their most recent Serie A title in 2000–01 under Fabio Capello, with Francesco Totti, Gabriel Batistuta, and Emerson forming an outstanding team that finished 2 points ahead of Juventus.'),

  (v_league, v_dc, 'Which Italian city''s derby is nicknamed "Derby del Sole" (Derby of the Sun)?',
   '["Rome","Naples","Genoa","Bari"]', 1, 'hard',
   'The Campania derby or southern Italian derbies have been referred to as "del Sole" given the southern Italian sunshine. Naples specifically features the Neapolitan derby between Napoli and various local rivals.'),

  (v_league, v_dc, 'What colour combination do Inter Milan wear?',
   '["Red and black","Blue and black","Black and white","Gold and black"]', 1, 'easy',
   'Inter Milan wear blue and black stripes ("nerazzurri" — black and blue). The colours were chosen in 1908 when the club was founded as a breakaway from AC Milan, who wear red and black ("rossoneri").'),

  (v_league, v_dc, 'Which milestone was achieved at the Derby della Madonnina in March 2022, with Inter winning 3-0?',
   '["Inter''s 100th derby victory","The 230th all-time Derby della Madonnina","AC Milan''s 200th appearance in the derby","The first derby played with fans back post-COVID"]', 1, 'hard',
   'The March 2022 Derby della Madonnina (Inter 3-0 AC Milan) was a Champions League quarter-final between the two Milan clubs — the first time they had met in European competition since 2005.'),

  (v_league, v_dc, 'In the 2023 UEFA Champions League semi-final, which Milan club knocked out the other?',
   '["AC Milan beat Inter Milan","Inter Milan beat AC Milan","They didn''t meet in the semi-final","The tie was abandoned"]', 1, 'medium',
   'Inter Milan beat AC Milan 3–0 on aggregate in the 2022–23 Champions League semi-finals (1–0 and 2–0), with goals from Romelu Lukaku and Lautaro Martínez sending Inter to the final in Istanbul.'),

  (v_league, v_dc, 'Which Roma player scored one of the most discussed goals in Derby della Capitale history to win the match in 2010?',
   '["Daniele De Rossi","Francesco Totti","Mirko Vučinić","David Pizarro"]', 2, 'hard',
   'Mirko Vučinić scored a famous overhead kick goal in the 2010 Derby della Capitale, celebrated widely as one of the most spectacular derby goals in Italian football history.'),

  (v_league, v_dc, 'What makes the Derby della Madonnina in the 2022–23 Champions League semi-final historically unique?',
   '["First European derby between the clubs","First all-Italian European semi-final since 2003","The first time both teams were drawn in the same pot","Both managers were Italian"]', 1, 'medium',
   'The 2022–23 Champions League semi-final between Inter Milan and AC Milan was the first all-Italian European semi-final in 20 years, since the same two clubs met in the 2002–03 semi-final (when AC Milan won).'),

  (v_league, v_dc, 'The 1985 Heysel Stadium disaster, during the European Cup Final, involved Juventus fans and supporters of which club?',
   '["AC Milan","Nottingham Forest","Liverpool","Bayern Munich"]', 2, 'medium',
   'The Heysel disaster occurred before the 1985 European Cup Final between Juventus and Liverpool. Thirty-nine Juventus supporters died when a wall collapsed after fighting broke out. Juventus won the match 1–0.'),

  (v_league, v_dc, 'Which Derby della Capitale is considered the most dangerous fixture in Italy from a public order perspective?',
   '["Juventus vs Torino","Lazio vs Roma","Genoa vs Sampdoria","Inter vs AC Milan"]', 1, 'medium',
   'The Lazio vs Roma Derby della Capitale is consistently ranked among the most volatile in world football. The fixture has been preceded by violent clashes and has been suspended on multiple occasions due to crowd trouble.'),

  (v_league, v_dc, 'What does "Treble" refer to in the context of Inter Milan 2009–10?',
   '["Serie A, Coppa Italia, Champions League","Serie A, Coppa Italia, Supercoppa","Serie A, Champions League, Club World Cup","Serie A, Champions League, Europa League"]', 0, 'easy',
   'Inter Milan''s Treble in 2009–10 under José Mourinho consisted of the Serie A title, the Coppa Italia, and the UEFA Champions League — one of football''s rarest and most prestigious achievements.'),

  (v_league, v_dc, 'Who manages Lazio and AS Roma respectively when the most recent Derby della Capitale was played?',
   '["This changes — managers change frequently","Allegri and Mancini","Inzaghi and Mourinho","Lotito and Pallotta"]', 0, 'easy',
   'Derby della Capitale managers change with appointment cycles. Between 2021–23, Mourinho managed Roma and Sarri managed Lazio — one of the most interesting managerial match-ups in recent Italian football.');

  -- ============================================================
  -- RECORDS & STATS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_rs, 'Which club holds the record for most Serie A titles?',
   '["Inter Milan","AC Milan","Juventus","AS Roma"]', 2, 'easy',
   'Juventus hold the record for most Serie A titles with 36 (including two awarded due to Calciopoli). However, two of those (2004–05 and 2005–06) were stripped and awarded to Inter Milan.'),

  (v_league, v_rs, 'What is the record for most consecutive Serie A titles won by a single club?',
   '["7","8","9","10"]', 2, 'medium',
   'Juventus won nine consecutive Serie A titles from 2011–12 to 2019–20 — the longest winning streak in Serie A history and one of the most dominant runs in European football.'),

  (v_league, v_rs, 'Gonzalo Higuaín set the Serie A single-season scoring record in 2015–16. How many goals did he score?',
   '["30","33","36","40"]', 2, 'medium',
   'Gonzalo Higuaín scored 36 Serie A goals for Napoli in 2015–16, breaking the single-season record and earning himself a controversial €90 million move to Juventus the following summer.'),

  (v_league, v_rs, 'Which club has never been relegated from Serie A since the league''s formation in 1929?',
   '["Juventus","AC Milan","Inter Milan","Fiorentina"]', 2, 'medium',
   'Inter Milan are the only club to have never been relegated from Serie A since the competition began in 1929, a feat that even Juventus (relegated in 2006 due to Calciopoli) cannot match.'),

  (v_league, v_rs, 'Ciro Immobile matched Higuaín''s Serie A scoring record in 2019–20. How many goals did he score?',
   '["32","34","36","38"]', 2, 'medium',
   'Ciro Immobile matched Gonzalo Higuaín''s Serie A record of 36 goals in the 2019–20 season for Lazio, also winning the European Golden Shoe that year.'),

  (v_league, v_rs, 'Which player holds the record for most Serie A appearances?',
   '["Alessandro Del Piero","Francesco Totti","Gianluigi Buffon","Paolo Maldini"]', 1, 'hard',
   'Francesco Totti made 619 Serie A appearances for AS Roma between 1992 and 2017 — the most by any player in the competition''s history. He scored 250 Serie A goals, also a Roma record.'),

  (v_league, v_rs, 'How many Serie A titles did Juventus win in a row from 2012 to 2020?',
   '["7","8","9","10"]', 2, 'easy',
   'Juventus won nine consecutive Serie A titles from 2011–12 to 2019–20 under coaches Antonio Conte (2012–14) and then Massimiliano Allegri (2014–19) before Maurizio Sarri (2019–20).'),

  (v_league, v_rs, 'Which club has won the most Coppa Italia titles?',
   '["Juventus","AC Milan","Inter Milan","AS Roma"]', 0, 'medium',
   'Juventus have won the Coppa Italia a record 15 times, making them the dominant force in Italian domestic cup football as well as the league.'),

  (v_league, v_rs, 'What is the record for most goals scored in a single Serie A season by a club?',
   '["98","106","115","121"]', 2, 'hard',
   'Juventus scored 98 goals in Serie A in the 2013–14 season — the competition record in the modern three-points era. Their 102-point tally that season is also the Serie A points record.'),

  (v_league, v_rs, 'How many points did Juventus accumulate in their record-breaking 2013–14 Serie A season?',
   '["96","100","102","106"]', 2, 'hard',
   'Juventus won 102 points in the 2013–14 Serie A season — the all-time points record in Italian football history. They finished 17 points ahead of second-placed Roma.'),

  (v_league, v_rs, 'Which Serie A player won the Capocannoniere (top scorer) award the most times?',
   '["Francesco Totti","Ciro Immobile","Silvio Piola","Gunnar Nordahl"]', 2, 'hard',
   'Silvio Piola won the Serie A Capocannoniere four times between 1936 and 1943. In the modern era, Francesco Totti won it once. Ciro Immobile has won it four times in the 21st century.'),

  (v_league, v_rs, 'AC Milan''s unbeaten run in all competitions from 1991 to 1993 lasted how many matches?',
   '["37","47","58","67"]', 2, 'hard',
   'AC Milan under Fabio Capello went 58 matches unbeaten in all competitions from 1991 to 1993, one of the longest unbeaten runs in football history.'),

  (v_league, v_rs, 'The Calciopoli scandal of 2006 resulted in which clubs being punished?',
   '["Only Juventus","Juventus, AC Milan, Fiorentina, Lazio, and Reggina","Juventus and Inter Milan","Juventus and AC Milan only"]', 1, 'hard',
   'The Calciopoli match-fixing scandal involved Juventus (relegated), AC Milan (points deduction), Fiorentina (points deduction), Lazio (points deduction), and Reggina (points deduction). Inter Milan were cleared of involvement.'),

  (v_league, v_rs, 'Napoli had not won Serie A between Maradona''s era and 2023. How many years was that gap?',
   '["22 years","28 years","33 years","40 years"]', 2, 'easy',
   'Napoli''s 2022–23 Serie A title ended a 33-year wait — their last previous title was in 1989–90. The victory under Luciano Spalletti with Victor Osimhen and Khvicha Kvaratskhelia was celebrated wildly in Naples.'),

  (v_league, v_rs, 'How many clubs were involved in the founding of Serie A in 1929?',
   '["12","16","18","20"]', 1, 'hard',
   'Serie A began in the 1929–30 season with 18 clubs participating in the first edition. The competition replaced the earlier Championship of Italy format which had used different formats since 1898.'),

  (v_league, v_rs, 'Which Italian club holds the European record for longest unbeaten home run in league football?',
   '["Juventus","Napoli","Inter Milan","AC Milan"]', 0, 'hard',
   'Juventus had an extraordinary unbeaten home run in Serie A extending over multiple seasons at both Stadio delle Alpi and the Juventus Stadium during their nine-title era.'),

  (v_league, v_rs, 'What was the record attendance for a Serie A match?',
   '["Over 90,000","Over 100,000","Around 80,000","Around 75,000"]', 1, 'hard',
   'The record Serie A attendance was approximately 100,000 at San Siro (which holds over 80,000 officially) or in earlier eras when stadiums were not all-seater. The Olimpico in Rome hosted over 90,000 in the 1980s.'),

  (v_league, v_rs, 'How many Serie A titles did AC Milan win in total?',
   '["14","16","19","22"]', 2, 'medium',
   'AC Milan have won 19 Serie A titles — second only to Juventus. Their most recent title came in 2021–22 under Stefano Pioli, ending an 11-year wait.'),

  (v_league, v_rs, 'Which was the lowest ever Serie A winning points total in the modern era (3 pts for win)?',
   '["68","72","75","80"]', 0, 'hard',
   'In unusual seasons with small competition fields or exceptional title races, winning totals can be low. In general the lowest modern era titles have been won with around 68–70 points — rare occurrences.'),

  (v_league, v_rs, 'Atalanta finished Serie A in which position in 2023–24 before winning the Europa League?',
   '["4th","5th","3rd","6th"]', 1, 'hard',
   'Atalanta finished 5th in Serie A 2023–24 while simultaneously winning the UEFA Europa League, defeating Bayer Leverkusen 3–0 in the final in Dublin. It was one of the greatest achievements in the club''s history.'),

  (v_league, v_rs, 'Serie A clubs have won the UEFA Champions League how many times combined?',
   '["10","12","15","18"]', 2, 'hard',
   'Italian clubs have won the European Cup/Champions League 12 times: Real Madrid (15) still leads, but Italy''s 12 wins (Juventus x2, AC Milan x7, Inter Milan x3) make it the second most successful country.'),

  (v_league, v_rs, 'Which Italian club won the Champions League in 2002–03 in a penalty shoot-out against Juventus?',
   '["Inter Milan","Napoli","AC Milan","Lazio"]', 2, 'medium',
   'AC Milan beat Juventus in the 2003 Champions League Final on penalties (3–2) after a 0–0 draw — the first all-Italian European Cup Final since 1983. Andriy Shevchenko scored the winning penalty.'),

  (v_league, v_rs, 'What is the Serie A record for most goals scored by one player in a single match?',
   '["5","6","7","8"]', 1, 'hard',
   'Six goals in a single Serie A match is the record, achieved by several players in early Serie A history. In the modern era, five goals in a match is considered exceptional.'),

  (v_league, v_rs, 'Lazio''s Serie A title in 1999–2000 was won by how many points from second-placed Juventus?',
   '["1","2","3","4"]', 0, 'hard',
   'Lazio won the 1999–2000 Serie A title by just 1 point from Juventus on the final day of the season. It remains one of the closest title races in Serie A history.'),

  (v_league, v_rs, 'The European Golden Shoe awarded to Serie A players — how many times has a Serie A player won it in the 21st century?',
   '["3","5","7","9"]', 1, 'hard',
   'Multiple Serie A players have won the European Golden Shoe in the 21st century: Francesco Totti (2006–07), Ciro Immobile (2019–20), Victor Osimhen (2022–23). The count depends on which years are included.'),

  (v_league, v_rs, 'Inter Milan''s 2023–24 Serie A title was their how-manyth?',
   '["17th","18th","19th","20th"]', 2, 'medium',
   'Inter Milan''s 2023–24 Serie A title was their 20th Scudetto, making them the second Italian club after Juventus to reach 20 titles. The star for 20 titles is added to their shirt.'),

  (v_league, v_rs, 'Juventus were relegated to Serie B in 2006 due to Calciopoli. They won promotion after one season and returned to Serie A for which season?',
   '["2006–07","2007–08","2008–09","2009–10"]', 1, 'medium',
   'Juventus were relegated to Serie B for the 2006–07 season after the Calciopoli scandal but won promotion at the first attempt, returning to Serie A for the 2007–08 season under Claudio Ranieri.'),

  (v_league, v_rs, 'AC Milan''s 2021–22 Serie A title ended a drought of how many years?',
   '["8 years","11 years","14 years","17 years"]', 1, 'medium',
   'AC Milan''s 2021–22 Serie A title ended an 11-year wait since their last championship in 2010–11. The title was won on the final day of the season under Stefano Pioli with goals from Rafael Leão and others.'),

  (v_league, v_rs, 'Which Serie A club was the last Italian team to reach the Champions League Final before 2022–23?',
   '["AS Roma","Juventus","Lazio","AC Milan"]', 1, 'hard',
   'Juventus reached the Champions League Final in 2014–15 (losing to Barcelona 3–1) and 2016–17 (losing to Real Madrid 4–1). AC Milan and Inter Milan''s final appearances were in 2007 and 2010 respectively.'),

  (v_league, v_rs, 'What is the record transfer fee paid by a Serie A club (as of 2024)?',
   '["€90m (Higuaín)","€100m (De Ligt)","€115m (Lukaku to Chelsea)","€108m (Dybala)"]', 1, 'hard',
   'Juventus''s €105.5 million purchase of Matthijs de Ligt from Ajax in 2019 is one of the highest fees ever paid by a Serie A club. The Higuaín deal (€90m from Napoli, 2016) was also record-breaking at the time.');

  -- ============================================================
  -- MANAGERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_mg, 'José Mourinho won the Serie A Treble with Inter Milan in which season?',
   '["2007–08","2008–09","2009–10","2010–11"]', 2, 'easy',
   'José Mourinho guided Inter Milan to the historic Treble (Serie A, Coppa Italia, Champions League) in 2009–10 before immediately leaving for Real Madrid. He remains the only manager to win the Treble with three different clubs.'),

  (v_league, v_mg, 'Which manager transformed AC Milan in the late 1980s with revolutionary pressing tactics?',
   '["Carlo Ancelotti","Fabio Capello","Arrigo Sacchi","Sven-Göran Eriksson"]', 2, 'easy',
   'Arrigo Sacchi revolutionised Italian football at AC Milan (1987–91), introducing high pressing and a flat back four that replaced traditional Italian catenaccio. He won two European Cups and was named the greatest coach of the 20th century by France Football.'),

  (v_league, v_mg, 'Carlo Ancelotti has managed how many Italian clubs in Serie A?',
   '["1","2","3","4"]', 1, 'medium',
   'Carlo Ancelotti managed AC Milan (winning the Champions League in 2003 and 2007) and Juventus (briefly in 1999–2001). He has also managed abroad at Chelsea, PSG, Real Madrid, Bayern Munich, Napoli, and Everton.'),

  (v_league, v_mg, 'Fabio Capello won Serie A how many times as a manager?',
   '["4","5","7","9"]', 2, 'hard',
   'Fabio Capello won Serie A seven times as manager: four times with AC Milan (1991–92, 1992–93, 1993–94, 1995–96) and three times with Roma (2000–01) and Juventus (twice). He also managed in Spain and England.'),

  (v_league, v_mg, 'Massimiliano Allegri won Serie A how many consecutive times at Juventus?',
   '["3","4","5","6"]', 2, 'medium',
   'Massimiliano Allegri won five consecutive Serie A titles at Juventus from 2014–15 to 2018–19, adding to the three won by Antonio Conte to give Juventus their nine-in-a-row run.'),

  (v_league, v_mg, 'Antonio Conte managed which club to break Juventus''s dominance in 2020–21?',
   '["Napoli","AC Milan","Inter Milan","Atalanta"]', 2, 'easy',
   'Antonio Conte managed Inter Milan to the 2020–21 Serie A title, ending Juventus''s nine-year run. Ironically, Conte himself had won three of those nine titles as Juventus manager earlier.'),

  (v_league, v_mg, 'Helenio Herrera managed "Grande Inter" to what achievements in the 1960s?',
   '["Serie A only","Champions League only","Serie A and Champions League twice","Serie A, Champions League, and Copa Italia"]', 2, 'medium',
   'Helenio Herrera''s Grande Inter won Serie A three times (1963, 1965, 1966) and the European Cup/Champions League twice (1964, 1965). His "catenaccio" defensive system defined Italian football for a generation.'),

  (v_league, v_mg, 'Sven-Göran Eriksson managed Lazio to their second Serie A title. Which country is he from?',
   '["Denmark","Norway","Sweden","Finland"]', 2, 'medium',
   'Sven-Göran Eriksson is Swedish and managed Lazio from 1997 to 2001, winning the Serie A title in 1999–2000 and the Coppa Italia. He later became England national team manager.'),

  (v_league, v_mg, 'Giovanni Trapattoni won Serie A with three different Italian clubs. Which are they?',
   '["Juventus, Inter, Fiorentina","Juventus, AC Milan, Inter","AC Milan, Napoli, Lazio","Inter, Napoli, Roma"]', 0, 'hard',
   'Giovanni Trapattoni won Serie A with Juventus (multiple times), Inter Milan, and Fiorentina — a unique achievement in Italian football management. He is considered one of Italy''s greatest managers.'),

  (v_league, v_mg, 'Luciano Spalletti managed Napoli to their 2022–23 title. Which other Serie A club did he famously manage?',
   '["AC Milan","Inter Milan","Juventus","AS Roma"]', 3, 'medium',
   'Luciano Spalletti managed AS Roma (2005–09 and 2016–17) and Inter Milan (2017–19) before guiding Napoli to Serie A in 2022–23. His tactical intelligence and man-management were key to Napoli''s triumph.'),

  (v_league, v_mg, 'Which manager led Napoli in the Maradona era and won the UEFA Cup in 1989?',
   '["Alberto Bigon","Ottavio Bianchi","Rino Marchesi","Dino Zoff"]', 1, 'hard',
   'Ottavio Bianchi managed Napoli from 1985 to 1989, winning two Serie A titles (1987, 1990 — the second with Alberto Bigon) and the UEFA Cup in 1989 with Diego Maradona as the central figure.'),

  (v_league, v_mg, 'Roberto Mancini managed Inter Milan and Manchester City before returning to Italy as what?',
   '["AC Milan manager","Italy national team manager","Juventus sporting director","Serie A referee coach"]', 1, 'medium',
   'Roberto Mancini managed Inter Milan (2004–2008 and briefly 2022–23) and Manchester City (winning the Premier League in 2012) before becoming Italy national team manager in 2018, guiding them to Euro 2020 glory.'),

  (v_league, v_mg, 'Which manager is credited with developing the "Sarrismo" possession-based style?',
   '["Carlo Ancelotti","Pep Guardiola","Maurizio Sarri","Arrigo Sacchi"]', 2, 'medium',
   '"Sarrismo" refers to Maurizio Sarri''s intense, possession-based 4-3-3 system he developed at Empoli before taking it to Napoli (2015–18), Chelsea (2018–19, winning the Europa League), and Juventus (2019–20).'),

  (v_league, v_mg, 'Marcello Lippi managed Juventus to multiple Serie A titles. How many did he win in total?',
   '["3","4","5","6"]', 2, 'medium',
   'Marcello Lippi won five Serie A titles with Juventus (1994–95, 1996–97, 1997–98, 2001–02, 2002–03) in two separate spells. He also managed Italy to the 2006 World Cup.'),

  (v_league, v_mg, 'Rudi García managed which two Serie A clubs in his Italian career?',
   '["Napoli and Juventus","Roma and Napoli","Fiorentina and AC Milan","Lazio and Inter"]', 1, 'medium',
   'Rudi García managed AS Roma (2013–2016, winning two consecutive second-place finishes) and Napoli (2023–24). He is French and previously managed Lille and Lyon.'),

  (v_league, v_mg, 'Which manager''s Serie A record of most seasons as a manager at the same club is considered remarkable?',
   '["Marcello Lippi (Juventus)","Antonio Conte (Juventus)","Massimiliano Allegri (Juventus)","Eusebio Di Francesco (Roma)"]', 2, 'hard',
   'Massimiliano Allegri spent five seasons in his first stint at Juventus (2014–19) and returned for a second stint (2021–24), making him one of the longest-serving Juventus managers in the modern era.'),

  (v_league, v_mg, 'Stefano Pioli managed AC Milan to their 2021–22 Serie A title. Which other clubs had he previously managed in Serie A?',
   '["Lazio, Fiorentina, Inter Milan","Roma, Napoli, Juventus","Atalanta, Lazio, Torino","Inter, Sampdoria, Roma"]', 0, 'hard',
   'Stefano Pioli managed Lazio, Fiorentina, and Inter Milan (briefly) before taking charge of AC Milan in 2019. His patience and development of players like Tonali, Leão, and Ibrahimović was key to the 2022 title.'),

  (v_league, v_mg, 'Which Juventus manager was the first to win the Serie A title with the club after their return from Serie B?',
   '["Antonio Conte","Claudio Ranieri","Ciro Ferrara","Dino Zoff"]', 1, 'hard',
   'Claudio Ranieri managed Juventus in their return to Serie A in 2007–08 but did not win the title. Antonio Conte won the first of nine consecutive titles from 2011–12.'),

  (v_league, v_mg, 'Which manager brought "Total Football" philosophy to Serie A in the 1990s?',
   '["Arrigo Sacchi","Johan Cruyff","Nereo Rocco","Trapattoni"]', 0, 'medium',
   'Arrigo Sacchi brought pressing and total football principles to Italy with AC Milan in the late 1980s, challenging traditional catenaccio. While not Total Football in the Dutch sense, his pressing game was revolutionary for Italian football.'),

  (v_league, v_mg, 'Which manager coached both Roma and Lazio in the Derby della Capitale?',
   '["Sven-Göran Eriksson","Fabio Capello","Zdeněk Zeman","Carlo Ancelotti"]', 2, 'hard',
   'Zdeněk Zeman is the only manager who has managed both Roma and Lazio in the Derby della Capitale. He managed Roma (twice: 1986–88 and 1997–98) and Lazio (1994–97), experiencing the derby from both sides.'),

  (v_league, v_mg, 'Walter Mazzarri managed Napoli before Sarri arrived. What was his style?',
   '["Tiki-taka possession","3-4-3 pressing football","5-3-2 defensive","Direct route one"]', 1, 'medium',
   'Walter Mazzarri was known for his dynamic 3-4-3 and 3-5-2 systems with high energy pressing. He managed Napoli from 2009 to 2013, taking them to second place in Serie A and two Coppa Italia Finals.'),

  (v_league, v_mg, 'Luca Gotti and Gian Piero Gasperini — which manager is most associated with transforming Atalanta?',
   '["Luca Gotti","Gian Piero Gasperini","Edoardo Reja","Stefano Colantuono"]', 1, 'easy',
   'Gian Piero Gasperini transformed Atalanta from a mid-table Serie A club into Champions League participants. Under him (2016–present), Atalanta reached the Champions League quarter-finals in 2019–20 and won the Europa League in 2023–24.'),

  (v_league, v_mg, 'Which Italian manager won the World Cup as a player and later won Serie A as a manager?',
   '["Arrigo Sacchi","Fabio Capello","Dino Zoff","Giovanni Trapattoni"]', 2, 'hard',
   'Dino Zoff was Italy''s World Cup-winning goalkeeper in 1982 and later managed Juventus and Lazio. He won the Coppa Italia with Lazio in 1997. Among the options, Trapattoni did not play at the highest international level.'),

  (v_league, v_mg, 'Which manager guided Fiorentina to a Copa Italia win and European glory in 1960–61?',
   '["Bruno Pesaola","Giuseppe Chiappella","Fulvio Bernardini","Nils Liedholm"]', 1, 'hard',
   'Giuseppe Chiappella managed Fiorentina to their only Coppa Italia title in 1960–61 and to the European Cup Winners'' Cup Final (1961, losing to Roma). He shaped the club''s golden era.'),

  (v_league, v_mg, 'Which Juventus manager was responsible for signing Zinedine Zidane, Alessandro Del Piero, and Gianluca Vialli in the 1990s?',
   '["Marcello Lippi","Giovanni Trapattoni","Carlo Ancelotti","Dino Zoff"]', 0, 'medium',
   'Marcello Lippi managed Juventus during their mid-1990s golden era, overseeing the signings of Zidane, and working with Del Piero and Vialli. He won the Champions League in 1995–96 and multiple Serie A titles.'),

  (v_league, v_mg, 'Nils Liedholm is known as one of the greatest foreign managers to coach in Serie A. Which nationality was he?',
   '["Dutch","Swedish","Norwegian","Danish"]', 1, 'hard',
   'Nils Liedholm was Swedish — a legendary figure in Italian football who played for AC Milan and later managed Roma and other clubs. He took Roma to their only European Cup Final in 1984 (losing to Liverpool).'),

  (v_league, v_mg, 'Which current Serie A club''s manager won the Champions League as a player with that same club?',
   '["Juventus (Del Piero)","AC Milan (Maldini)","Inter (Milito)","Roma (Totti)"]', 1, 'hard',
   'Paolo Maldini won the Champions League as a player with AC Milan and later became Technical Director of the club. Totti remained at Roma in an ambassador role, not as manager.'),

  (v_league, v_mg, 'Antonio Conte is known for his intense training methods. Which club did he manage before joining Juventus?',
   '["Bari","Atalanta","Siena","Napoli"]', 2, 'medium',
   'Antonio Conte managed Siena before joining Juventus in 2011. He had also managed Arezzo, Bari, and Atalanta earlier in his career. His tenure at Juventus from 2011–14 began the nine-consecutive-title era.'),

  (v_league, v_mg, 'Which manager replaced José Mourinho at AS Roma in 2024?',
   '["Daniele De Rossi","Claudio Ranieri","Vincenzo Italiano","Paulo Fonseca"]', 0, 'medium',
   'Daniele De Rossi replaced José Mourinho as Roma manager in January 2024 when Mourinho was sacked. De Rossi, a club legend, was a popular choice with the Roma fanbase.');

  -- ============================================================
  -- TRANSFERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_tr, 'Gonzalo Higuaín''s transfer from Napoli to Juventus in 2016 involved what fee, then a Serie A record?',
   '["€70m","€80m","€90m","€100m"]', 2, 'medium',
   'Gonzalo Higuaín moved from Napoli to Juventus for €90 million in July 2016, a record fee for a Serie A club at the time. Napoli fans were furious, viewing it as a betrayal after his 36-goal season.'),

  (v_league, v_tr, 'Matthijs de Ligt moved from Ajax to Juventus in 2019 for approximately how much?',
   '["€75m","€85.5m","€95m","€100m"]', 1, 'medium',
   'Matthijs de Ligt joined Juventus from Ajax for €85.5 million in July 2019, one of the most expensive defensive transfers in history. He later moved to Bayern Munich for €67 million in 2022.'),

  (v_league, v_tr, 'Romelu Lukaku moved from Manchester United to Inter Milan in 2019. What was the fee?',
   '["€60m","€70m","€80m","€90m"]', 2, 'medium',
   'Romelu Lukaku joined Inter Milan from Manchester United for €80 million in August 2019. He became a key figure in Inter''s 2020–21 Serie A title win before controversially moving to Chelsea for €115m.'),

  (v_league, v_tr, 'Which player joined Juventus from Barcelona for €105m in 2017?',
   '["Miralem Pjanić","Dani Alves","Paulo Dybala","No player — this transfer did not happen"]', 3, 'hard',
   'No player moved from Barcelona to Juventus for €105m. The notable 2017 transfer was Dani Alves joining Juventus on a free. Juventus''s biggest incoming was De Ligt (€85.5m) from Ajax in 2019.'),

  (v_league, v_tr, 'In 2022, Erling Haaland left Borussia Dortmund for Manchester City. Had he ever played in Serie A?',
   '["Yes — for Napoli","Yes — for Juventus","Yes — for RB Salzburg in Italy (Italian league)","No — he never played in Serie A"]', 3, 'easy',
   'Erling Haaland never played in Serie A. His career before Manchester City took him from Molde to Salzburg to Borussia Dortmund. Several Italian clubs were reportedly interested, but he chose the Premier League.'),

  (v_league, v_tr, 'Diego Maradona''s transfer to Napoli from Barcelona in 1984 was a world record. What was the fee?',
   '["€7m","€10.48m","€12m","€15m"]', 1, 'medium',
   'Diego Maradona joined Napoli from FC Barcelona for €10.48 million in July 1984 — a world record at the time. President Corrado Ferlaino broke the bank to sign the player who would transform the club''s history.'),

  (v_league, v_tr, 'Andriy Shevchenko joined which club from Dynamo Kyiv in 1999?',
   '["Juventus","Inter Milan","AC Milan","Fiorentina"]', 2, 'medium',
   'Andriy Shevchenko joined AC Milan from Dynamo Kyiv for €25 million in 1999 and became one of Serie A''s greatest strikers, winning the Champions League and the 2004 Ballon d''Or.'),

  (v_league, v_tr, 'Paul Pogba returned to Juventus from Manchester United in 2022 as a free agent. What had his 2016 world record move from Juventus to United cost?',
   '["£70m","£80m","£89m","£100m"]', 2, 'medium',
   'Paul Pogba moved from Juventus to Manchester United for £89 million in August 2016 — a then world record transfer. He rejoined Juventus for free in 2022 but was plagued by injuries and banned for doping.'),

  (v_league, v_tr, 'Gabriel Batistuta left Fiorentina for AS Roma in 2000. How much was the fee?',
   '["€25m","€32m","€40m","€48m"]', 2, 'hard',
   'Gabriel Batistuta left Fiorentina for AS Roma for approximately €40 million in 2000, helping Roma win Serie A in 2000–01. It was an emotional departure from Florence, where he had become a legend.'),

  (v_league, v_tr, 'Which Serie A club sold Gianluigi Buffon to Juventus for a then world record fee for a goalkeeper in 2001?',
   '["Parma","Fiorentina","Lazio","Sampdoria"]', 0, 'medium',
   'Gianluigi Buffon joined Juventus from Parma for €52.88 million in 2001 — a world record fee for a goalkeeper at the time. He spent 17 seasons at Juventus, winning 10 Serie A titles.'),

  (v_league, v_tr, 'Which player did Inter Milan sell to Tottenham in 2012, making it a notable Serie A exit?',
   '["Luka Modrić","Emmanuel Adebayor","Gareth Bale","Sandro"]', 3, 'hard',
   'Sandro (Alessandro Rodrigo) joined Tottenham from Inter Milan in 2012. Inter also sold Wesley Sneijder and Esteban Cambiasso during their post-Mourinho rebuilding phase.'),

  (v_league, v_tr, 'Zlatan Ibrahimović joined Inter Milan from Juventus in 2006 for how much?',
   '["€24.8m","€35m","€48m","€60m"]', 0, 'hard',
   'Zlatan Ibrahimović joined Inter Milan from Juventus for €24.8 million in 2006 as part of the Calciopoli fallout. He later moved to Barcelona for €69.5 million in 2009.'),

  (v_league, v_tr, 'Victor Osimhen joined Napoli from Lille in 2020 for approximately how much?',
   '["€50m","€70m","€81.3m","€95m"]', 2, 'medium',
   'Victor Osimhen joined Napoli from Lille for approximately €70-81 million (with add-ons) in October 2020, a club record. He went on to win the Capocannoniere and help Napoli to the 2022–23 Serie A title.'),

  (v_league, v_tr, 'Christian Pulisic joined AC Milan from Chelsea as a free/loan in 2023. Where is he from?',
   '["USA","Canada","England","Germany"]', 0, 'easy',
   'Christian Pulisic is American (from Hershey, Pennsylvania) and joined AC Milan from Chelsea in July 2023 for approximately €20 million. He became one of the first American stars to shine in Serie A.'),

  (v_league, v_tr, 'Which Serie A club sold Kalidou Koulibaly to Chelsea in 2022?',
   '["AC Milan","Juventus","Napoli","Inter Milan"]', 2, 'medium',
   'Kalidou Koulibaly joined Chelsea from Napoli for approximately €40 million in July 2022. He had been one of Serie A''s best defenders during his 8 years at Napoli.'),

  (v_league, v_tr, 'Romelu Lukaku''s transfer from Inter to Chelsea in 2021 set a record for a Serie A outgoing transfer. What was the fee?',
   '["€95m","€105m","€115m","€125m"]', 2, 'medium',
   'Romelu Lukaku moved from Inter Milan to Chelsea for €115 million in August 2021 — the most expensive outgoing transfer from a Serie A club at the time. He struggled at Chelsea before returning to Inter on loan.'),

  (v_league, v_tr, 'Roberto Baggio''s surprise transfer from Fiorentina to Juventus in 1990 caused riots in Florence. How much was the fee?',
   '["€4m","€8m","€12m","€18m"]', 1, 'hard',
   'Roberto Baggio''s move from Fiorentina to Juventus for approximately £7.7 million (then Lire equivalent) in 1990 caused riots in Florence. Fans burned cars and protested violently outside the stadium.'),

  (v_league, v_tr, 'Khvicha Kvaratskhelia joined Napoli in 2022 for a bargain fee. How much did Napoli pay?',
   '["€4.5m","€10m","€20m","€35m"]', 1, 'hard',
   'Napoli signed Khvicha Kvaratskhelia from Dinamo Batumi for approximately €10 million in 2022 — one of football''s greatest bargain signings. He won Serie A in his debut season and was named Serie A''s best player, before eventually joining PSG.'),

  (v_league, v_tr, 'AC Milan sold Andriy Shevchenko to Chelsea in 2006 for how much?',
   '["€30m","£30m","£30.8m","€45m"]', 2, 'hard',
   'Andriy Shevchenko moved from AC Milan to Chelsea for £30.8 million in June 2006, reuniting with José Mourinho''s team. Unfortunately, he never reproduced his Milan brilliance in the Premier League.'),

  (v_league, v_tr, 'Inter Milan signed Lautaro Martínez from Racing Club in 2018 for how much?',
   '["€15m","€22.7m","€30m","€35m"]', 1, 'medium',
   'Lautaro Martínez joined Inter Milan from Racing Club in Argentina for €22.7 million in 2018. He has since become one of Serie A''s best strikers, winning the World Cup with Argentina in 2022.'),

  (v_league, v_tr, 'Juventus signed Cristiano Ronaldo from Real Madrid in 2018 for how much?',
   '["€90m","€100m","€112m","€120m"]', 2, 'medium',
   'Cristiano Ronaldo joined Juventus from Real Madrid for €112 million in July 2018, at age 33. Despite scoring 101 goals in three seasons, Juventus failed to win the Champions League, the primary aim of the signing.'),

  (v_league, v_tr, 'Which Serie A club is known for developing and selling talent at a premium, regularly topping transfer income tables?',
   '["Atalanta","Sassuolo","Udinese","Empoli"]', 0, 'medium',
   'Atalanta have become Europe''s premier talent development club, selling players like Dejan Kulusevski, Merih Demiral, and Franck Kessié at significant profit while developing new stars through their renowned Bergamo academy.'),

  (v_league, v_tr, 'Alessandro Del Piero spent his whole career at Juventus. When he left in 2012, which club did he join?',
   '["Chelsea","Sydney FC","LA Galaxy","Paris Saint-Germain"]', 1, 'medium',
   'Alessandro Del Piero joined Sydney FC in Australia in 2012 after leaving Juventus at age 37. He spent one season in the A-League, drawing enormous crowds and demonstrating his enduring quality.'),

  (v_league, v_tr, 'Napoli captain Lorenzo Insigne left the club as a free agent in 2022. Which club did he join?',
   '["New York City FC","Toronto FC","Inter Miami","CF Montréal"]', 1, 'medium',
   'Lorenzo Insigne, Napoli''s captain, left as a free agent in summer 2022 to join Toronto FC in MLS on a lucrative long-term deal. He had scored 122 goals for Napoli in 11 seasons and his departure was an emotional moment for the club and its fans.'),

  (v_league, v_tr, 'Which Serie A club sold Frenkie de Jong to FC Barcelona?',
   '["AC Milan","Juventus","Inter Milan","None — he came from Ajax"]', 3, 'medium',
   'Frenkie de Jong joined FC Barcelona directly from Ajax in 2019, never having played in Serie A. His brother Luuk de Jong has played in Serie A at various clubs.'),

  (v_league, v_tr, 'Mauro Icardi left Inter Milan for Paris Saint-Germain in 2019. What was the fee?',
   '["€50m","€60m","€70m","€80m"]', 1, 'hard',
   'Mauro Icardi joined PSG from Inter Milan for €60 million in September 2019 after a complex contract saga that saw him stripped of the Inter captaincy and excluded from the squad.'),

  (v_league, v_tr, 'Brazilian midfielder Jorginho joined Chelsea from Napoli in 2018 following which manager?',
   '["José Mourinho","Antonio Conte","Maurizio Sarri","Carlo Ancelotti"]', 2, 'medium',
   'Jorginho followed Maurizio Sarri from Napoli to Chelsea in 2018 for approximately £57 million. Sarri''s preferred deep-lying playmaker role for Jorginho was central to his "Sarrismo" system.'),

  (v_league, v_tr, 'Which Serie A club agreed a deal to sign Antonio Rudiger from Chelsea in 2022 on a free transfer?',
   '["Juventus","AC Milan","Inter Milan","Real Madrid"]', 3, 'hard',
   'Antonio Rudiger joined Real Madrid (not a Serie A club) on a free transfer from Chelsea in 2022. Italian clubs like Juventus were linked but Real Madrid won the race for the German defender.'),

  (v_league, v_tr, 'Sandro Tonali left AC Milan for Newcastle United in 2023 for how much?',
   '["€55m","€60m","€70m","€80m"]', 2, 'medium',
   'Sandro Tonali joined Newcastle United from AC Milan for €70 million in July 2023 in a then record sale for Milan. He subsequently received a ban for betting violations in Italy.');

  -- ============================================================
  -- STADIUM & CULTURE (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_sc, 'What is the official name of the stadium shared by AC Milan and Inter Milan?',
   '["Stadio San Siro","Stadio Giuseppe Meazza","Stadio Nerazzurro","Stadio Rossonero"]', 1, 'medium',
   'The stadium is officially named Stadio Giuseppe Meazza, after Italy''s legendary inter-war striker. It is colloquially known as "San Siro" after the neighbourhood in Milan where it is located.'),

  (v_league, v_sc, 'What is the capacity of the San Siro/Giuseppe Meazza stadium?',
   '["65,000","72,000","75,923","80,000"]', 2, 'medium',
   'The Stadio Giuseppe Meazza (San Siro) has an official capacity of 75,923, making it one of the largest stadiums in Europe. Both AC Milan and Inter are planning a potential new stadium to replace it.'),

  (v_league, v_sc, 'Serie A''s nickname "Calcio" is an Italian word for what?',
   '["Pass","Kick","Ball","Goal"]', 1, 'easy',
   '"Calcio" literally means "kick" in Italian, reflecting football''s original description as a kicking game. It has been used as Italy''s term for football since the sport was introduced in the late 19th century.'),

  (v_league, v_sc, 'The "ultras" culture in Italian football is known for what?',
   '["Family-friendly viewing areas","Spectacular choreographies and passionate but often violent support","Corporate hospitality events","Television punditry culture"]', 1, 'easy',
   'Italian ultras are known worldwide for their elaborate tifo displays (choreographies), drums, flares, and intensely passionate — sometimes violent — support. The culture originated in Italy in the late 1960s.'),

  (v_league, v_sc, 'What is the name of the trophy awarded to the Serie A champion?',
   '["La Coppa","Lo Scudetto","Il Trofeo","La Serie"]', 1, 'easy',
   'The Serie A champion is awarded "Lo Scudetto" (The Little Shield), a gold star that is worn on the shirt in the following season. The Scudetto is also represented as a badge on the champion''s kit.'),

  (v_league, v_sc, 'The Stadio Olimpico in Rome has been the home of both Lazio and Roma since which year?',
   '["1953","1958","1962","1968"]', 2, 'hard',
   'The Stadio Olimpico was built in 1953 for the 1960 Rome Olympics and became home to both Lazio and AS Roma. It hosted the 1990 World Cup Final between West Germany and Argentina.'),

  (v_league, v_sc, 'What Italian gesture is associated with goal celebrations and defying critics?',
   '["The Bellissimo sign","The Mamma mia gesture","The Balotelli shirt lift","No specific gesture"]', 2, 'hard',
   'Mario Balotelli''s shirt lift revealing "Why Always Me?" became iconic, but more broadly, Italian goal celebration gestures — including the "Quenelle" (since banned) and various arm gestures — have generated significant controversy.'),

  (v_league, v_sc, 'Juventus Stadium was renamed after which brand when it opened in 2011?',
   '["Pirelli Stadium","Fiat Stadium","Allianz Stadium","Pirlo Stadium"]', 2, 'medium',
   'Juventus''s stadium was initially called Juventus Stadium when it opened in September 2011. It was renamed Allianz Stadium in 2017 after a naming rights deal with the German insurance company.'),

  (v_league, v_sc, 'AC Milan''s famous home kit is which colour combination?',
   '["Black and blue stripes","Red and white stripes","Red and black stripes","Gold and red stripes"]', 2, 'easy',
   'AC Milan wear red and black vertical stripes ("Rossoneri") — a kit inspired by their devil/devil''s colours nickname. The "Diavolo Rosso" identity has been part of the club since its English founders adopted the colours.'),

  (v_league, v_sc, 'The term "catenaccio" in Italian football describes which tactical system?',
   '["High press attacking football","Physical long-ball football","Defensive system with man-marking and a sweeper","Total football with position rotations"]', 2, 'medium',
   '"Catenaccio" (meaning "door bolt" or "chain") is an Italian defensive system featuring tight marking, a sweeper (libero) behind the defenders, and organised shape. It was dominant in Serie A from the 1950s to the 1970s.'),

  (v_league, v_sc, 'Naples, Napoli''s city, is known for its passionate football culture. What statue stands in the city celebrating which player?',
   '["Roberto Baggio","Diego Maradona","Gianluigi Buffon","Ciro Immobile"]', 1, 'easy',
   'Naples has erected multiple murals, plaques, and a full statue in honour of Diego Maradona, who is worshipped as a god in the city. Even after his death in 2020, the tributes to him in Naples are extraordinary.'),

  (v_league, v_sc, 'Napoli renamed their stadium after which legendary player following his death in 2020?',
   '["Gennaro Gattuso","Diego Maradona","Ciro Immobile","Dries Mertens"]', 1, 'easy',
   'Napoli renamed the Stadio San Paolo as the "Stadio Diego Armando Maradona" following the death of Diego Maradona on 25 November 2020. The renaming reflected Maradona''s god-like status in Naples.'),

  (v_league, v_sc, 'What is the term for when a Serie A club wins the league title?',
   '["Campione","Scudetto","Tricolore","Palmarès"]', 1, 'easy',
   'Winning the Serie A title is called winning "Lo Scudetto" — the small shield badge that champions wear on their shirts the following season. The term is deeply embedded in Italian football culture.'),

  (v_league, v_sc, 'What colour is the Serie A Scudetto badge?',
   '["Blue and gold","Green white and red","Blue with a star","Black and gold"]', 1, 'medium',
   'The Scudetto badge features the green, white, and red of the Italian flag — a tricolore design — applied to the shield. The champion wears this badge on their shirt throughout the following season.'),

  (v_league, v_sc, 'How many stars does Juventus wear on their shirt for winning the league?',
   '["1 star (10 titles)","2 stars (20 titles)","3 stars (30 titles)","A different system"]', 3, 'hard',
   'Italian clubs wear gold stars on their shirts for every 10 Serie A titles won (one star = 10 titles). Juventus wear three stars for their 30+ titles. Inter Milan celebrated their 20th title with a second star in 2024.'),

  (v_league, v_sc, 'The "Juventini" term refers to what?',
   '["Juventus youth academy players","Juventus fans","Former Juventus players","Juventus''s B-team"]', 1, 'easy',
   '"Juventini" is the Italian term for Juventus fans. The club is the most supported in Italy, with a nationwide fanbase. This is a source of resentment among rival clubs'' supporters.'),

  (v_league, v_sc, 'What historical event deeply divided Italian football in 2006?',
   '["Italy''s World Cup win","The Calciopoli scandal","The Superga disaster anniversary","Serie A rebranding"]', 1, 'easy',
   'The Calciopoli scandal of 2006 divided Italian football: Juventus were relegated, Milan and others were docked points, while Inter benefited enormously despite later investigations suggesting they may not have been entirely clean.'),

  (v_league, v_sc, 'Fiorentina''s nickname "Viola" refers to which colour?',
   '["Dark blue","Violet/Purple","Light blue","Navy"]', 1, 'easy',
   '"Viola" means violet or purple in Italian. Fiorentina''s distinctive violet (or dark purple) kit has been their trademark since the 1920s and has been controversial — some consider purple an unlucky colour in Italian superstition.'),

  (v_league, v_sc, 'Tifo displays in Italian football are famous worldwide. What is a "tifo"?',
   '["A football chant","A choreographed visual display using cards, banners, and flares","A penalty technique","A defensive formation"]', 1, 'easy',
   'A "tifo" (from "tifoso," meaning fan) is an elaborate choreography performed by the ultras sections of Italian stadiums. They use coloured cards, giant banners, smoke flares, and coordinated movements to create visual spectacles.'),

  (v_league, v_sc, 'The Italian football phrase "il bel gioco" means what?',
   '["The defensive game","The beautiful game","The fast game","The technical game"]', 1, 'easy',
   '"Il bel gioco" (The beautiful game) is Italian football''s philosophical ideal — technically brilliant, aesthetically pleasing football. It is considered the pinnacle of what Italian football should aspire to, though pragmatism has often prevailed.'),

  (v_league, v_sc, 'Which Italian city is home to clubs from BOTH Genoa CFC and Sampdoria?',
   '["Turin","Rome","Genoa","Venice"]', 2, 'easy',
   'Genoa CFC and Sampdoria are both based in the city of Genoa (Genova). Their Derby della Lanterna is one of Italy''s oldest local rivalries, dating back to the early 20th century.'),

  (v_league, v_sc, 'The Juventus away kit is traditionally which colour?',
   '["All white","Light blue and black","All black","White and blue"]', 0, 'medium',
   'Juventus''s away kit is traditionally all white, contrasting with their famous black and white stripes. Their home kit''s distinctive vertical stripes have made them one of the world''s most recognisable football clubs.'),

  (v_league, v_sc, 'The 1990 FIFA World Cup was hosted in Italy. Which Italian city hosted the final?',
   '["Naples","Milan","Turin","Rome"]', 3, 'easy',
   'The 1990 FIFA World Cup Final between West Germany and Argentina was played at the Stadio Olimpico in Rome on 8 July 1990. West Germany won 1–0 with a late Andreas Brehme penalty.'),

  (v_league, v_sc, 'Atalanta is nicknamed "La Dea" (The Goddess). When did they first qualify for the Champions League?',
   '["2016–17","2018–19","2019–20","2021–22"]', 2, 'medium',
   'Atalanta qualified for the Champions League for the first time in their history in 2019–20 after finishing third in Serie A in 2018–19 under Gian Piero Gasperini. They then reached the quarter-finals.'),

  (v_league, v_sc, 'Which city''s team is nicknamed "Il Diavolo" (The Devil)?',
   '["Inter Milan","AS Roma","AC Milan","Juventus"]', 2, 'easy',
   'AC Milan are nicknamed "Il Diavolo" (The Devil) and "Rossoneri" (Red and Blacks). The devil theme comes from their red and black colours, associated with hellfire and the devil''s imagery.'),

  (v_league, v_sc, 'What is "catenaccio" most directly translated to in English?',
   '["The Lock","The Chain","The Door Bolt","All of these"]', 3, 'medium',
   '"Catenaccio" literally means "door bolt" (catena = chain, suggesting locking). In football parlance it refers to an extremely defensive style of play, locking out the opposition and focusing on counterattacks.'),

  (v_league, v_sc, 'Lazio''s colours — sky blue and white — have earned them which nickname?',
   '["I Biancocelesti","La Aquila","I Laziali","I Celesti"]', 0, 'medium',
   'Lazio are nicknamed "I Biancocelesti" (The White and Sky Blues) for their light blue and white kit. Their emblem features an eagle (Aquila), the symbol of the ancient Roman Empire.'),

  (v_league, v_sc, 'Which Italian club''s crest features a red cross on a white background?',
   '["AC Milan","Juventus","AS Roma","Inter Milan"]', 0, 'medium',
   'AC Milan''s crest features a red cross on a white background — the cross of Saint George, the symbol of the city of Milan. The English founders of the club adopted this symbol in honour of their homeland.'),

  (v_league, v_sc, 'The "Supercoppa Italiana" is played between which two clubs each season?',
   '["Serie A champion vs Europa League winner","Serie A champion vs Coppa Italia winner","Last season''s top two clubs","Depends on the season format"]', 1, 'easy',
   'The Supercoppa Italiana (Italian Super Cup) is traditionally contested between the Serie A champion and the Coppa Italia winner. In recent years it has been expanded to a four-team tournament.'),

  (v_league, v_sc, 'In which year did Italy win the World Cup most recently?',
   '["1994","1998","2006","2014"]', 2, 'easy',
   'Italy won the FIFA World Cup in 2006 in Germany, defeating France on penalties after a 1–1 draw in the final. It was their fourth World Cup title, making them joint-second behind Brazil at the time.');

end;
$$;
