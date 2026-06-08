-- ============================================================
-- LeagueIQ — Seed: EPL Questions (210)
-- 30 per category × 7 categories
-- ============================================================

do $$
declare
  v_league  uuid := '11111111-1111-1111-1111-111111111111';
  v_ch      uuid; -- club_history
  v_fp      uuid; -- famous_players
  v_im      uuid; -- iconic_matches
  v_rs      uuid; -- records_stats
  v_mg      uuid; -- managers
  v_tr      uuid; -- transfers
  v_sc      uuid; -- stadium_culture
begin
  select id into v_ch from public.categories where league_id = v_league and slug = 'club_history';
  select id into v_fp from public.categories where league_id = v_league and slug = 'famous_players';
  select id into v_im from public.categories where league_id = v_league and slug = 'iconic_matches';
  select id into v_rs from public.categories where league_id = v_league and slug = 'records_stats';
  select id into v_mg from public.categories where league_id = v_league and slug = 'managers';
  select id into v_tr from public.categories where league_id = v_league and slug = 'transfers';
  select id into v_sc from public.categories where league_id = v_league and slug = 'stadium_culture';

  -- ============================================================
  -- CLUB HISTORY (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_ch, 'In what year was Arsenal Football Club founded?',
   '["1882","1886","1890","1895"]', 1, 'easy',
   'Arsenal was founded in 1886 as Dial Square by munitions workers at the Royal Arsenal in Woolwich, south-east London.'),

  (v_league, v_ch, 'What was Arsenal''s original name when founded in 1886?',
   '["Woolwich Rangers","Dial Square","Royal Arsenal FC","Gunners FC"]', 1, 'medium',
   'The club was named Dial Square after one of the workshops at the Royal Arsenal. It was renamed Royal Arsenal shortly after, then Woolwich Arsenal.'),

  (v_league, v_ch, 'In what year was Chelsea Football Club founded?',
   '["1899","1902","1905","1910"]', 2, 'easy',
   'Chelsea was founded in 1905 specifically to occupy Stamford Bridge, which had been built but had no tenant club.'),

  (v_league, v_ch, 'Which club was the first winner of the Premier League in the 1992–93 season?',
   '["Arsenal","Blackburn Rovers","Manchester United","Leeds United"]', 2, 'easy',
   'Manchester United won the inaugural Premier League title in 1992–93 with manager Alex Ferguson, ending their 26-year wait for a top-flight championship.'),

  (v_league, v_ch, 'Blackburn Rovers won the Premier League title in which season?',
   '["1993–94","1994–95","1995–96","1996–97"]', 1, 'medium',
   'Backed by owner Jack Walker''s investment, Blackburn pipped Manchester United on the final day of the 1994–95 season, with Alan Shearer scoring 34 league goals.'),

  (v_league, v_ch, 'Leicester City won their first and only Premier League title in which season?',
   '["2014–15","2015–16","2016–17","2017–18"]', 1, 'easy',
   'Leicester City were 5000/1 outsiders at the start of the 2015–16 season, making their title triumph one of the greatest sporting upsets in history.'),

  (v_league, v_ch, 'What was Manchester United''s original name before they became "Manchester United" in 1902?',
   '["Manchester FC","Salford City","Newton Heath","Trafford FC"]', 2, 'medium',
   'Manchester United were founded in 1878 as Newton Heath LYR Football Club by workers of the Lancashire and Yorkshire Railway.'),

  (v_league, v_ch, 'What was Manchester City''s original name when founded in 1880?',
   '["Gorton FC","St Mark''s (West Gorton)","Ardwick AFC","Hyde Road FC"]', 1, 'hard',
   'Manchester City were founded in 1880 as St Mark''s (West Gorton), later becoming Ardwick AFC before adopting the name Manchester City in 1894.'),

  (v_league, v_ch, 'Everton Football Club was originally formed under what name in 1878?',
   '["Stanley FC","St Domingo''s FC","Everton Rangers","Anfield FC"]', 1, 'medium',
   'Everton began as St Domingo''s FC, a church team from the St Domingo Methodist New Connexion Chapel in Everton, Liverpool.'),

  (v_league, v_ch, 'In what year was Liverpool Football Club founded?',
   '["1888","1890","1892","1894"]', 2, 'easy',
   'Liverpool FC was founded in 1892 after a dispute between Everton and their landlord John Houlding, who then founded a new club to play at Anfield.'),

  (v_league, v_ch, 'Aston Villa were founding members of which league in 1888?',
   '["The Premier League","The Football League","The Football Association","The Southern League"]', 1, 'medium',
   'Aston Villa were one of the 12 founding members of the Football League in 1888, along with clubs like Everton, Blackburn Rovers and Wolverhampton Wanderers.'),

  (v_league, v_ch, 'Tottenham Hotspur was founded in which year?',
   '["1878","1880","1882","1884"]', 2, 'medium',
   'Tottenham Hotspur were founded in 1882 by a group of schoolboys from the Hotspur Cricket Club in Tottenham, north London.'),

  (v_league, v_ch, 'What was West Ham United originally known as when founded in 1895?',
   '["East London FC","Thames Ironworks FC","West Ham City","Hammers United"]', 1, 'medium',
   'West Ham were founded in 1895 as Thames Ironworks FC, a works team for the Thames Ironworks and Shipbuilding Company. The crossed riveting hammers on their crest reflect this heritage.'),

  (v_league, v_ch, 'Arsenal''s famous "Invincibles" season, when they went unbeaten in the Premier League, was which year?',
   '["2002–03","2003–04","2004–05","2005–06"]', 1, 'easy',
   'Arsenal went the entire 2003–04 Premier League season unbeaten (26 wins, 12 draws), becoming the first side to win the title without losing since Preston North End in 1888–89.'),

  (v_league, v_ch, 'Newcastle United was founded in which year?',
   '["1888","1890","1892","1895"]', 2, 'medium',
   'Newcastle United was formed in 1892 through the merger of two local clubs, Newcastle East End and Newcastle West End.'),

  (v_league, v_ch, 'Which club did Arsenal merge with to become the dominant London club in the early 20th century?',
   '["Fulham","Woolwich Arsenal and Norris FC","They did not merge with anyone","Millwall"]', 2, 'hard',
   'Arsenal never merged — the club simply relocated from Woolwich to Highbury in north London in 1913, a controversial move orchestrated by chairman Henry Norris.'),

  (v_league, v_ch, 'How many times had Arsenal won the First Division/Premier League title as of the end of the 2023–24 season?',
   '["11","13","15","17"]', 1, 'medium',
   'Arsenal have won the English top-flight title 13 times in total — 10 First Division titles and 3 Premier League titles (1997–98, 2001–02, 2003–04).'),

  (v_league, v_ch, 'Manchester United have won the most Premier League titles. How many have they won?',
   '["11","13","15","17"]', 1, 'easy',
   'Manchester United won 13 Premier League titles between 1992–93 and 2012–13, all under manager Sir Alex Ferguson.'),

  (v_league, v_ch, 'In which year did Arsenal leave Highbury for the Emirates Stadium?',
   '["2004","2005","2006","2007"]', 2, 'easy',
   'Arsenal moved to the 60,000-seat Emirates Stadium in 2006, leaving Highbury where they had played since 1913.'),

  (v_league, v_ch, 'Which Premier League club has been relegated and promoted back to the top flight the most times?',
   '["Sunderland","Birmingham City","West Bromwich Albion","Norwich City"]', 2, 'hard',
   'West Bromwich Albion have been promoted back to the Premier League four times (and relegated four times), the joint most with clubs like Sunderland.'),

  (v_league, v_ch, 'Chelsea won their first ever top-flight English championship in which year?',
   '["1949","1955","1962","1970"]', 1, 'hard',
   'Chelsea''s first and only First Division title came in 1954–55. They would not win the league again until 2004–05, exactly 50 years later.'),

  (v_league, v_ch, 'Which year did Tottenham last win the English top-flight title?',
   '["1951","1961","1971","1981"]', 1, 'hard',
   'Tottenham''s last top-flight title was in 1960–61 when they became the first team in the 20th century to win the League and FA Cup Double.'),

  (v_league, v_ch, 'Liverpool''s 30-year wait for a league title ended in which year?',
   '["2018","2019","2020","2021"]', 2, 'easy',
   'Liverpool ended their 30-year wait for a league title in 2019–20, with Jürgen Klopp''s side clinching the championship with seven games to spare.'),

  (v_league, v_ch, 'Which club holds the record for the most FA Cup wins?',
   '["Manchester United","Arsenal","Chelsea","Tottenham Hotspur"]', 1, 'medium',
   'Arsenal have won the FA Cup a record 14 times, with their most recent victory in 2019–20 under Mikel Arteta.'),

  (v_league, v_ch, 'Derby County set the record for the worst points total in a Premier League season. How many points did they finish with in 2007–08?',
   '["11","15","17","19"]', 0, 'medium',
   'Derby County finished the 2007–08 Premier League season with just 11 points (1 win, 8 draws, 29 losses), the worst record in Premier League history.'),

  (v_league, v_ch, 'Which club was the first to win back-to-back Premier League titles twice?',
   '["Arsenal","Chelsea","Manchester United","Manchester City"]', 2, 'hard',
   'Manchester United won back-to-back titles in 1992–94, 1995–97, 1998–2001, and 2006–09 — no other club has won consecutive Premier League titles more than once.'),

  (v_league, v_ch, 'In what decade was the Premier League founded?',
   '["1970s","1980s","1990s","2000s"]', 2, 'easy',
   'The Premier League was formed in 1992 when top-flight clubs broke away from the Football League to negotiate their own television deals, initially with BSkyB.'),

  (v_league, v_ch, 'Which was the first club to win the Premier League three seasons in a row?',
   '["Arsenal","Chelsea","Manchester United","Manchester City"]', 2, 'medium',
   'Manchester United won three consecutive Premier League titles from 1998–99 to 2000–01, and later from 2006–07 to 2008–09.'),

  (v_league, v_ch, 'The "Class of 92" refers to a group of youth players who came through which club''s academy?',
   '["Arsenal","Liverpool","Manchester United","Chelsea"]', 2, 'easy',
   'The Class of 92 — Scholes, Giggs, Beckham, Butt, G. Neville and P. Neville — all graduated from Manchester United''s youth academy and went on to define an era.'),

  (v_league, v_ch, 'Which club plays their home games at Villa Park?',
   '["Birmingham City","Wolverhampton Wanderers","Aston Villa","West Bromwich Albion"]', 2, 'easy',
   'Aston Villa have played at Villa Park since 1897. The ground hosted six matches at the 1966 FIFA World Cup and has a current capacity of around 42,788.');

  -- ============================================================
  -- FAMOUS PLAYERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_fp, 'Who is the all-time top scorer in Premier League history?',
   '["Wayne Rooney","Thierry Henry","Andrew Cole","Alan Shearer"]', 3, 'easy',
   'Alan Shearer scored 260 Premier League goals across his career at Southampton, Blackburn Rovers and Newcastle United — a record that has stood since 2006.'),

  (v_league, v_fp, 'Which player made the most Premier League appearances ever, with 653 games?',
   '["Ryan Giggs","Steven Gerrard","Gareth Barry","Frank Lampard"]', 2, 'medium',
   'Gareth Barry holds the record for most Premier League appearances with 653 games across Aston Villa, Manchester City, Everton and West Bromwich Albion.'),

  (v_league, v_fp, 'Thierry Henry scored how many Premier League goals for Arsenal?',
   '["155","165","175","185"]', 2, 'medium',
   'Thierry Henry scored 175 Premier League goals for Arsenal across two spells (1999–2007 and 2012), making him the club''s all-time top scorer.'),

  (v_league, v_fp, 'Which player has scored the most Premier League hat-tricks, with 12?',
   '["Alan Shearer","Wayne Rooney","Sergio Agüero","Michael Owen"]', 2, 'hard',
   'Sergio Agüero scored 12 Premier League hat-tricks during his time at Manchester City (2011–2021), surpassing Alan Shearer''s previous record of 11.'),

  (v_league, v_fp, 'Which nationality was Premier League legend Éric Cantona?',
   '["Belgian","Swiss","French","Algerian"]', 2, 'easy',
   'Éric Cantona was born in Paris and played for France before becoming a cult hero at Manchester United, where he won four Premier League titles in five seasons.'),

  (v_league, v_fp, 'Steven Gerrard spent his entire Premier League career at which club?',
   '["Arsenal","Everton","Liverpool","Tottenham"]', 2, 'easy',
   'Steven Gerrard made 504 Premier League appearances for Liverpool between 1998 and 2015, yet famously never won the Premier League title.'),

  (v_league, v_fp, 'Which goalkeeper won five Premier League titles with Manchester United and is considered one of the best ever?',
   '["David De Gea","Edwin van der Sar","Peter Schmeichel","Mark Bosnich"]', 2, 'easy',
   'Peter Schmeichel won 5 Premier League titles with Manchester United (1992–93, 1993–94, 1995–96, 1996–97, 1998–99) and is widely regarded as the greatest goalkeeper in Premier League history.'),

  (v_league, v_fp, 'Frank Lampard is Chelsea''s all-time top scorer. How many goals did he score for the club?',
   '["179","195","211","227"]', 2, 'medium',
   'Frank Lampard scored 211 goals in all competitions for Chelsea (1999–2014), making him the club''s record goalscorer and one of the greatest midfielders in Premier League history.'),

  (v_league, v_fp, 'Who scored Arsenal''s stunning long-range opening goal against Chelsea in the 2002 FA Cup Final, sparking a 2–0 victory?',
   '["Robert Pires","Freddie Ljungberg","Marc Overmars","Ray Parlour"]', 3, 'hard',
   'Ray Parlour struck a superb long-range effort past Fabian Barthez to open the scoring in Arsenal''s 2–0 win over Chelsea in the 2002 FA Cup Final at the Millennium Stadium. Freddie Ljungberg added the second to complete the Double.'),

  (v_league, v_fp, 'Dennis Bergkamp''s iconic goal against which club in March 2002 is often called the greatest Premier League goal ever?',
   '["Manchester United","Chelsea","Newcastle United","Liverpool"]', 2, 'medium',
   'Dennis Bergkamp''s goal against Newcastle United in March 2002 — controlling a long pass, flicking it past a defender, and volleying into the corner — was voted the greatest Arsenal goal ever.'),

  (v_league, v_fp, 'Wayne Rooney left which club to join Manchester United in 2004?',
   '["Sunderland","Liverpool","Everton","Manchester City"]', 2, 'easy',
   'Wayne Rooney burst onto the scene at Everton, scoring on his Premier League debut aged 16, before joining Manchester United in August 2004 for £25.6 million.'),

  (v_league, v_fp, 'Which Liverpool legend scored 346 goals in all competitions, the most by any player in the club''s history?',
   '["Kenny Dalglish","Ian Rush","Roger Hunt","Billy Liddell"]', 1, 'medium',
   'Ian Rush scored 346 goals in all competitions for Liverpool across two spells (1980–87 and 1988–96), making him the club''s all-time leading scorer.'),

  (v_league, v_fp, 'Which player won the Premier League Golden Boot four times, the most of any player in the competition''s history?',
   '["Alan Shearer","Thierry Henry","Andrew Cole","Kevin Phillips"]', 1, 'hard',
   'Thierry Henry won the Premier League Golden Boot four times (2001–02 with 24 goals, 2003–04 with 30, 2004–05 with 25, and 2005–06 with 27) — more than any other player in the competition''s history.'),

  (v_league, v_fp, 'Robbie Fowler earned which nickname at Liverpool due to his prolific goalscoring?',
   '["The Terminator","God","The Rocket","Super Rob"]', 1, 'medium',
   'Robbie Fowler was nicknamed "God" by Liverpool fans after scoring 120 Premier League goals for the club. He also netted the fastest Premier League hat-trick, in just 4 minutes 33 seconds against Arsenal in 1994.'),

  (v_league, v_fp, 'Who was the first player to score 100 Premier League goals?',
   '["Ian Wright","Alan Shearer","Les Ferdinand","Andy Cole"]', 1, 'hard',
   'Alan Shearer was the first player to reach the 100 Premier League goal landmark, doing so in October 1995 while at Blackburn Rovers.'),

  (v_league, v_fp, 'Sergio Agüero is Manchester City''s all-time Premier League top scorer. How many Premier League goals did he score for the club?',
   '["158","169","184","198"]', 2, 'medium',
   'Sergio Agüero scored 184 Premier League goals for Manchester City (2011–2021) — the most by any player for a single club in Premier League history. He also scored 12 Premier League hat-tricks, another record.'),

  (v_league, v_fp, 'Who wore the number 7 shirt for Manchester United most famously before Cristiano Ronaldo?',
   '["Eric Cantona","Mark Hughes","Bryan Robson","David Beckham"]', 3, 'medium',
   'David Beckham wore United''s iconic number 7 shirt from 1997 to 2003, following in the footsteps of legends like George Best, Bryan Robson, and Éric Cantona.'),

  (v_league, v_fp, 'Patrick Vieira captained Arsenal for many years. Which country does he represent internationally?',
   '["Senegal","France","Algeria","Ivory Coast"]', 1, 'easy',
   'Patrick Vieira was born in Senegal but moved to France as a child and represented the French national team, winning the 1998 World Cup and Euro 2000.'),

  (v_league, v_fp, 'Steve Watson scored a famous long-range lob from his own half in the Premier League in 1997. Which rival club did the Newcastle defender score against?',
   '["Leeds United","Middlesbrough","Sheffield Wednesday","Sunderland"]', 3, 'hard',
   'Steve Watson scored a lob from inside his own half for Newcastle United against Sunderland in February 1997, one of the most memorable long-range efforts in Premier League history alongside David Beckham''s famous goal against Wimbledon.'),

  (v_league, v_fp, 'David Beckham scored his famous halfway line goal against which club in August 1996?',
   '["Southampton","Wimbledon","Crystal Palace","Charlton Athletic"]', 1, 'medium',
   'David Beckham spotted goalkeeper Neil Sullivan off his line and lobbed him from inside his own half at Selhurst Park, scoring one of the most iconic goals in Premier League history.'),

  (v_league, v_fp, 'Which striker scored 34 goals in the 1994–95 Premier League season, a record at the time?',
   '["Robbie Fowler","Les Ferdinand","Andrew Cole","Alan Shearer"]', 3, 'hard',
   'Alan Shearer scored 34 goals for Blackburn Rovers in the 1994–95 season, helping them win the Premier League title. He shares the single-season record with Andrew Cole (1993–94).'),

  (v_league, v_fp, 'Which Tottenham and England striker was known as the "Ghost" for his ability to ghost into goal-scoring positions?',
   '["Gary Lineker","Glenn Hoddle","Teddy Sheringham","Peter Beardsley"]', 0, 'medium',
   'Gary Lineker was nicknamed "The Ghost" for his predatory movement in the penalty area. He scored 80 Premier League goals for Spurs and led the 1986 World Cup Golden Boot standings.'),

  (v_league, v_fp, 'Who won the inaugural Premier League Player of the Season award in 1992–93?',
   '["Eric Cantona","Paul McGrath","Ryan Giggs","Peter Schmeichel"]', 0, 'hard',
   'Éric Cantona won the first Premier League Player of the Season award in 1992–93, helping Manchester United to their first top-flight title in 26 years. Ryan Giggs won the PFA Young Player of the Year that same season.'),

  (v_league, v_fp, 'Which player scored on the opening day of every Premier League season he played in, a remarkable consistency record?',
   '["Teddy Sheringham","Les Ferdinand","Andrew Cole","Ian Wright"]', 0, 'hard',
   'Teddy Sheringham scored on the opening day of the Premier League in multiple consecutive seasons, though Ian Wright is equally celebrated for his consistent Premier League goal-scoring throughout the 1990s.'),

  (v_league, v_fp, 'Which French midfielder joined Arsenal from Monaco in 1996 and transformed the club?',
   '["Patrick Vieira","Thierry Henry","Sylvain Wiltord","Robert Pires"]', 0, 'medium',
   'Patrick Vieira joined Arsenal from AC Milan (on loan from Monaco) in August 1996 and quickly became the heartbeat of Arsène Wenger''s dominant side, making over 400 appearances for the club.'),

  (v_league, v_fp, 'Cristiano Ronaldo joined Manchester United from which club in 2003?',
   '["Benfica","Porto","Sporting CP","Braga"]', 2, 'easy',
   'Cristiano Ronaldo joined Manchester United from Sporting CP for £12.24 million in August 2003, becoming Sir Alex Ferguson''s first choice to replace David Beckham.'),

  (v_league, v_fp, 'Which Premier League goalkeeper has kept the most clean sheets in the competition''s history?',
   '["Peter Schmeichel","Edwin van der Sar","David James","Petr Čech"]', 3, 'hard',
   'Petr Čech holds the record for the most Premier League clean sheets with 202, accumulated during his time at Chelsea (2004–2015) and Arsenal (2015–2019).'),

  (v_league, v_fp, 'Which striker scored 34 goals in the 1993–94 Premier League season for Newcastle, sharing the single-season record?',
   '["Robbie Fowler","Les Ferdinand","Alan Shearer","Andrew Cole"]', 3, 'medium',
   'Andrew Cole scored 34 Premier League goals for Newcastle United in 1993–94, sharing the all-time single-season record with Alan Shearer (Blackburn, 1994–95).'),

  (v_league, v_fp, 'Which player scored the Premier League''s fastest ever goal in 7.69 seconds in May 2019?',
   '["Jamie Vardy","Shane Long","Dele Alli","Glenn Murray"]', 1, 'hard',
   'Shane Long scored after just 7.69 seconds for Southampton against Watford on 23 April 2019, the fastest goal in Premier League history.'),

  (v_league, v_fp, 'Which Arsenal and France forward won the 2003–04 PFA Players'' Player of the Year?',
   '["Patrick Vieira","Robert Pires","Thierry Henry","Ashley Cole"]', 2, 'medium',
   'Thierry Henry won the PFA Players'' Player of the Year in 2003–04, the same season Arsenal went unbeaten. He also won the FWA Footballer of the Year that year.'),

  (v_league, v_fp, 'Which Chelsea striker scored in four consecutive FA Cup finals between 2007 and 2012?',
   '["Frank Lampard","Nicolas Anelka","Didier Drogba","John Terry"]', 2, 'medium',
   'Didier Drogba scored in four FA Cup finals for Chelsea — 2007, 2009, 2010, and 2012 — making him one of the most important players in the club''s history.');

  -- ============================================================
  -- ICONIC MATCHES (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_im, 'What is the score of the famous 1996 match between Liverpool and Newcastle, often called "The Greatest Premier League Game"?',
   '["3–2","4–3","5–4","3–1"]', 1, 'medium',
   'Liverpool beat Newcastle 4–3 at Anfield in April 1996 in a breathtaking encounter. Kevin Keegan''s Newcastle had been 12 points clear at the top of the table earlier that season.'),

  (v_league, v_im, 'In the famous "Agueroooo!" moment, what was the final score when Manchester City beat QPR on the last day of the 2011–12 season?',
   '["2–1","3–2","4–2","2–0"]', 1, 'easy',
   'Sergio Agüero scored in the 93rd minute and 20 seconds to make it 3–2 against QPR, sealing Manchester City''s first Premier League title on goal difference from Manchester United.'),

  (v_league, v_im, 'What was the score when Manchester United beat Arsenal 8–2 in August 2011?',
   '["6–1","7–2","8–2","9–2"]', 2, 'easy',
   'Manchester United beat Arsenal 8–2 at Old Trafford in August 2011, with Wayne Rooney scoring a hat-trick. It remains Arsenal''s worst Premier League defeat.'),

  (v_league, v_im, 'Liverpool famously came back from 3–0 down to beat AC Milan in the 2005 Champions League final. What was the final score after extra time?',
   '["3–3 (3–2 on pens)","4–3 (4–3 on pens)","3–3 (3–3 AET, 3–2 on pens)","4–4 (4–2 on pens)"]', 2, 'medium',
   'Liverpool trailed 3–0 at half-time in Istanbul but scored three goals in six second-half minutes through Gerrard, Šmicer, and Alonso. They won on penalties 3–2, delivering the "Miracle of Istanbul".'),

  (v_league, v_im, 'Manchester City beat Tottenham 4–3 in a thrilling Champions League quarter-final second leg in April 2019. What was the aggregate score?',
   '["4–3","4–4","5–4","7–6"]', 1, 'hard',
   'Tottenham went through 4–4 on aggregate on away goals after a stunning 4–3 second-leg defeat at the Etihad. Fernando Llorente''s controversial hip/hand goal was allowed to stand.'),

  (v_league, v_im, 'Chelsea beat Arsenal 6–0 at Stamford Bridge in March 2014 in which competition?',
   '["FA Cup","Premier League","League Cup","Champions League"]', 1, 'medium',
   'Chelsea beat Arsenal 6–0 in the Premier League at Stamford Bridge on 22 March 2014. It remains Arsenal''s worst ever defeat against a London rival.'),

  (v_league, v_im, 'In which match did Michael Thomas score a famous injury-time winner to give Arsenal the First Division title in 1989?',
   '["Arsenal vs Tottenham","Liverpool vs Arsenal","Arsenal vs Manchester United","Everton vs Arsenal"]', 1, 'hard',
   'Michael Thomas scored in injury time at Anfield to give Arsenal a 2–0 win. Arsenal needed to win by two goals to pip Liverpool on goal difference — and did it in the most dramatic fashion.'),

  (v_league, v_im, 'The "Battle of the Buffet" in October 2004 occurred after Arsenal''s 49-game unbeaten run ended. What is the match best remembered for?',
   '["A tunnel brawl","A pizza thrown at Sir Alex Ferguson","A mass red card","A penalty controversy"]', 1, 'hard',
   'Arsenal''s 49-game unbeaten Premier League run ended with a 2–0 loss at Old Trafford on 24 October 2004. In the tunnel afterwards, Cesc Fàbregas allegedly threw a slice of pizza at Sir Alex Ferguson — an incident known as "Pizzagate."'),

  (v_league, v_im, 'Arsenal''s unbeaten Premier League run ended at 49 games. Which club ended it in October 2004?',
   '["Chelsea","Tottenham","Manchester United","Blackburn Rovers"]', 3, 'medium',
   'Blackburn Rovers ended Arsenal''s 49-game unbeaten run in the Premier League with a 2–0 win at Ewood Park in October 2004 — the first time Arsenal had lost in the league since May 2003.'),

  (v_league, v_im, 'Which match did Sir Alex Ferguson call Manchester United''s "hardest ever victory"? (Champions League Final 1999)',
   '["vs Bayern Munich","vs Juventus","vs Barcelona","vs Inter Milan"]', 0, 'medium',
   'Manchester United beat Bayern Munich 2–1 in stoppage time at Camp Nou to complete the Treble in 1999. Both Teddy Sheringham and Ole Gunnar Solskjær scored as substitutes in injury time.'),

  (v_league, v_im, 'Liverpool beat Barcelona 4–0 in the 2018–19 Champions League semi-final second leg, overturning a 3–0 deficit. Who scored twice?',
   '["Sadio Mané","Mohamed Salah","Roberto Firmino","Divock Origi"]', 3, 'hard',
   'Divock Origi scored twice, with Georginio Wijnaldum also bagging a brace, as Liverpool produced one of the greatest Champions League comebacks at Anfield. Barcelona didn''t register a shot on target.'),

  (v_league, v_im, 'The famous "Gerrard slip" cost Liverpool the Premier League title in 2013–14 in a match against which club?',
   '["Manchester City","Chelsea","Arsenal","Everton"]', 1, 'medium',
   'Steven Gerrard''s slip let in Demba Ba to score for Chelsea in a 2–0 win at Anfield in April 2014, a match Liverpool needed to win to stay on course for the title. Manchester City subsequently overtook them.'),

  (v_league, v_im, 'Which final was dubbed the "Miracle at the Millennium" when Liverpool beat Arsenal on penalties to win the FA Cup in 2001?',
   '["2001 FA Cup Final","2001 League Cup Final","2001 UEFA Cup Final","None — they lost"]', 0, 'hard',
   'Liverpool beat Arsenal 2–1 in the 2001 FA Cup Final at the Millennium Stadium in Cardiff, with Freddie Ljungberg''s equaliser cancelled out by Michael Owen''s two late goals.'),

  (v_league, v_im, 'Which match in May 2012 saw Chelsea beat Bayern Munich on penalties to win the Champions League on their home ground?',
   '["Camp Nou","Allianz Arena","Wembley","San Siro"]', 1, 'medium',
   'Chelsea beat Bayern Munich 4–3 on penalties in the Champions League Final at the Allianz Arena — Bayern''s home ground — in May 2012. Didier Drogba''s late header forced extra time.'),

  (v_league, v_im, 'Manchester United''s famous 5–3 win at Stamford Bridge in 1999 featured a late winner from which player?',
   '["Roy Keane","Andy Cole","Teddy Sheringham","Dwight Yorke"]', 1, 'hard',
   'Andy Cole scored a hat-trick in Manchester United''s 5–3 win at Chelsea in February 1999, a key result in their historic Treble-winning season.'),

  (v_league, v_im, 'In the 2006 FA Cup Final, who scored the winning penalty as Liverpool beat West Ham in a shoot-out?',
   '["Steven Gerrard","Robbie Fowler","John Arne Riise","Jamie Carragher"]', 0, 'hard',
   'Steven Gerrard won the man of the match award, scoring a stunning long-range equaliser to take the game to extra time. Liverpool won 3–1 on penalties after a 3–3 draw.'),

  (v_league, v_im, 'Tottenham famously dropped points at what became known as "that day at St James'' Park" in 1996, helping Man United win the title?',
   '["2–2 vs Newcastle","1–4 vs Newcastle","0–1 vs Manchester United","2–1 vs Arsenal"]', 1, 'hard',
   'Tottenham were hammered 4–1 by Newcastle at St James'' Park in May 1996, a result which helped Manchester United win the Premier League title on the final day.'),

  (v_league, v_im, 'In which season did Arsenal beat Manchester United 3–0 at Old Trafford to maintain their unbeaten run?',
   '["2001–02","2002–03","2003–04","2004–05"]', 2, 'medium',
   'Arsenal beat Manchester United 3–0 at Old Trafford in September 2003, with goals from Henry (pen), Ljungberg, and Pires. This was a key result in the Invincibles'' 49-game unbeaten run.'),

  (v_league, v_im, 'Which match is known as the "Vicente Calderón Miracle" for Arsenal''s comeback against Villarreal in 2006?',
   '["Champions League Semi-Final 2006","Champions League Final 2006","Europa League Final 2009","This match does not exist"]', 0, 'hard',
   'Arsenal''s Champions League semi-final against Villarreal in 2006 is celebrated as a defensive masterclass — Jens Lehmann saved a late penalty to help Arsenal advance 1–0 on aggregate.'),

  (v_league, v_im, 'Manchester City''s 6–1 victory at Manchester United in October 2011 was their biggest Old Trafford win. What was notable about the scoreline?',
   '["Man City were 3–0 down at half-time","Mario Balotelli revealed a t-shirt saying ''Why Always Me?''","Tevez scored 4 goals","The game was decided by 3 own goals"]', 1, 'medium',
   'After scoring, Mario Balotelli lifted his shirt to reveal the famous "Why Always Me?" t-shirt, one of the most iconic moments in Premier League rivalry history.'),

  (v_league, v_im, 'Brian Clough''s Nottingham Forest won the 1979 European Cup Final 1–0. Who scored the only goal, making him the first £1 million player in British football?',
   '["Martin O''Neill","Tony Woodcock","Trevor Francis","Garry Birtles"]', 2, 'hard',
   'Trevor Francis scored the only goal as Nottingham Forest beat Malmö FF 1–0 in the 1979 European Cup Final in Munich. Francis had become Britain''s first £1 million player when Forest signed him from Birmingham City earlier that year.'),

  (v_league, v_im, 'In the 2018–19 Premier League season, which match saw Liverpool draw 0–0 to allow Manchester City to win the title on the final day?',
   '["Liverpool vs Wolves","Liverpool vs Brighton","Liverpool vs Arsenal","Liverpool vs Watford"]', 1, 'hard',
   'Brighton held Liverpool to a 0–0 draw on the final day of the 2018–19 Premier League season. Manchester City beat Brighton 4–1 to win the title on goal difference, with Liverpool finishing on 97 points.'),

  (v_league, v_im, 'The "Battle of the Buffet" occurred after Arsenal lost their 49-game unbeaten run. Which player allegedly threw pizza?',
   '["Thierry Henry","Patrick Vieira","Cesc Fabregas","Robert Pires"]', 2, 'hard',
   'Cesc Fabregas was widely credited with throwing a slice of pizza at Sir Alex Ferguson after Arsenal''s 2–0 loss at Old Trafford in October 2004. The incident became known as "Pizzagate".'),

  (v_league, v_im, 'In Liverpool''s famous 4–3 win over Newcastle in 1996, who scored the winning goal?',
   '["Robbie Fowler","Stan Collymore","Ian Rush","Steve McManaman"]', 1, 'medium',
   'Stan Collymore''s injury-time winner — captured in a famous photo of Kevin Keegan slumped against the dugout — sealed the game and broke Newcastle hearts in the title race.'),

  (v_league, v_im, 'Leicester City''s title-winning 2015–16 campaign included a famous 3–1 win over which defending champions on the opening day?',
   '["Chelsea","Manchester City","Arsenal","Tottenham"]', 0, 'hard',
   'Leicester beat Sunderland on the opening day, but their statement result came later. Their 3–1 win over defending champions Chelsea on 14 December 2015 announced them as serious title contenders.'),

  (v_league, v_im, 'In the 2013–14 PL season, Manchester City beat rivals Manchester United 4-1 in the league. Who scored a hat-trick?',
   '["Sergio Agüero","Carlos Tevez","Samir Nasri","Yaya Touré"]', 0, 'hard',
   'Sergio Agüero scored a hat-trick in Manchester City''s 4–1 win over Manchester United at the Etihad in February 2014, a dominant display in the rivalry.'),

  (v_league, v_im, 'In the Champions League Round of 16 in 2012, Arsenal famously beat AC Milan 3–0. Who scored twice in that match?',
   '["Theo Walcott","Robin van Persie","Olivier Giroud","Lukas Podolski"]', 1, 'medium',
   'Robin van Persie scored twice, including a brilliant first-time volley, as Arsenal overturned a 4–0 aggregate deficit to beat AC Milan 3–0 at the Emirates — though they still went out.'),

  (v_league, v_im, 'Tottenham Hotspur''s new stadium opened in 2019 with a league game against which club?',
   '["Arsenal","Liverpool","Crystal Palace","Manchester City"]', 2, 'medium',
   'Tottenham''s new stadium hosted its first Premier League game against Crystal Palace on 3 April 2019, with a goal from Christian Eriksen sealing a 2–0 win.'),

  (v_league, v_im, 'Manchester United beat Chelsea 4–0 in the 1994 FA Cup Final. Who scored two penalties in that match to complete the Double?',
   '["Ryan Giggs","Mark Hughes","Eric Cantona","Paul Ince"]', 2, 'hard',
   'Éric Cantona scored two penalties in Manchester United''s 4–0 win over Chelsea in the 1994 FA Cup Final at Wembley. United had also won the Premier League that season — their first Double.'),

  (v_league, v_im, 'In which famous match did Robbie Fowler score the fastest Premier League hat-trick (4 minutes 33 seconds) against Arsenal in 1994?',
   '["Anfield","Highbury","Villa Park","Stamford Bridge"]', 0, 'hard',
   'Robbie Fowler''s hat-trick at Anfield on 28 August 1994 took just 4 minutes and 33 seconds — still the fastest hat-trick in Premier League history.'),

  (v_league, v_im, 'What was the score when Tottenham beat Newcastle 7–1 in a famous 1996 Premier League match?',
   '["5–1","6–1","7–1","7–2"]', 2, 'hard',
   'Tottenham beat Newcastle 7–1 at White Hart Lane in December 1996, with Sheringham and Armstrong both scoring twice. It remains one of the most remarkable results in Premier League history.');

  -- ============================================================
  -- RECORDS & STATS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_rs, 'How many goals did Alan Shearer score in his Premier League career?',
   '["220","240","260","280"]', 2, 'easy',
   'Alan Shearer scored 260 Premier League goals — 23 for Southampton, 112 for Blackburn Rovers, and 125 for Newcastle United — a record unlikely to be broken.'),

  (v_league, v_rs, 'How many clubs have been in the Premier League every season since its formation in 1992?',
   '["4","5","6","7"]', 2, 'medium',
   'Six clubs have been ever-present in the Premier League: Arsenal, Chelsea, Everton, Liverpool, Manchester United and Tottenham Hotspur.'),

  (v_league, v_rs, 'What is the record for the most points in a single Premier League season?',
   '["95","97","98","100"]', 3, 'medium',
   'Manchester City set the record with 100 points in the 2017–18 Premier League season under Pep Guardiola, winning 32 of their 38 games.'),

  (v_league, v_rs, 'Which player holds the record for most Premier League assists with 162?',
   '["Ryan Giggs","David Beckham","Cesc Fàbregas","Wayne Rooney"]', 2, 'hard',
   'Cesc Fàbregas retired as the Premier League''s all-time leading assist provider with 162 assists, accumulating them at Arsenal, Chelsea, and during his time in England.'),

  (v_league, v_rs, 'The biggest ever Premier League win (9–0) has been achieved by which two clubs?',
   '["Man Utd and Man City","Leicester and Man Utd","Man Utd and Liverpool","Chelsea and Liverpool"]', 1, 'hard',
   'Manchester United beat Ipswich 9–0 in March 1995, and Leicester City also beat Southampton 9–0 in October 2019. Both remain joint record PL wins.'),

  (v_league, v_rs, 'How many Premier League seasons did Arsène Wenger manage Arsenal for?',
   '["18","20","22","24"]', 2, 'medium',
   'Arsène Wenger managed Arsenal for 22 seasons (1996–2018), winning three Premier League titles, seven FA Cups, and transforming the club into a global brand.'),

  (v_league, v_rs, 'Which team went an entire Premier League season without winning an away match?',
   '["Sunderland","Derby County","Hull City","Huddersfield Town"]', 1, 'medium',
   'Derby County went the entire 2007–08 season without winning an away match — in fact they won only one match all season. Their 11 points remains the all-time Premier League low.'),

  (v_league, v_rs, 'What is the fewest goals scored by a Premier League top scorer in a season (Golden Boot)?',
   '["10","12","14","18"]', 2, 'hard',
   'In the 1994–95 season, the Golden Boot was shared by five players with 18 goals each. However, in shortened or unusual seasons, the total can be as low as 14.'),

  (v_league, v_rs, 'Which Premier League season saw the most goals scored in total across all 380 matches?',
   '["2011–12","2018–19","2022–23","2019–20"]', 1, 'hard',
   'The 2018–19 Premier League season saw a record 1,072 goals scored across all 380 matches, the highest total in the competition''s history.'),

  (v_league, v_rs, 'How many red cards did Patrick Vieira receive in the Premier League, a joint record?',
   '["6","8","10","12"]', 1, 'hard',
   'Patrick Vieira received 8 Premier League red cards, a record shared with several other players. His combative style made him both feared and adored.'),

  (v_league, v_rs, 'What is the record for most Premier League goals in a calendar year?',
   '["34","36","39","41"]', 2, 'hard',
   'Alan Shearer scored 36 Premier League goals in the calendar year of 1995, a record that stood for many years before being challenged by more recent strikers.'),

  (v_league, v_rs, 'Manchester City scored how many goals in their record-breaking 2017–18 Premier League season?',
   '["90","96","106","112"]', 2, 'medium',
   'Manchester City scored 106 Premier League goals in 2017–18, the first time any side had broken the 100-goal barrier in a Premier League season.'),

  (v_league, v_rs, 'Which goalkeeper kept the most consecutive Premier League clean sheets, with 14?',
   '["Petr Čech","Peter Schmeichel","Edwin van der Sar","David De Gea"]', 2, 'hard',
   'Edwin van der Sar kept 14 consecutive Premier League clean sheets for Manchester United in 2008–09, going 1,311 minutes without conceding — another long-standing record.'),

  (v_league, v_rs, 'What is the fastest Premier League goal ever scored, set in 2019?',
   '["9.9 seconds","7.69 seconds","8.5 seconds","11 seconds"]', 1, 'medium',
   'Shane Long scored after just 7.69 seconds for Southampton against Watford on 23 April 2019, beating the previous record of 9.9 seconds held by Ledley King since 2000.'),

  (v_league, v_rs, 'Which club has suffered the most Premier League relegations?',
   '["Sunderland","Wolverhampton Wanderers","West Bromwich Albion","Leicester City"]', 0, 'hard',
   'Sunderland and West Bromwich Albion have each been relegated from the Premier League on multiple occasions, highlighting the volatility of top-flight status for historically yo-yo clubs.'),

  (v_league, v_rs, 'The highest attendance ever recorded at a Premier League match was at which ground?',
   '["Old Trafford","Wembley","City of Manchester Stadium","Villa Park"]', 0, 'medium',
   'Old Trafford regularly hosted crowds over 75,000 during the early Premier League era, with a record of 76,098 recorded — the highest in Premier League history.'),

  (v_league, v_rs, 'Robbie Fowler scored the fastest ever Premier League hat-trick in how many minutes and seconds?',
   '["3:12","4:33","5:01","4:02"]', 1, 'medium',
   'Robbie Fowler scored a hat-trick in 4 minutes and 33 seconds against Arsenal at Anfield in August 1994. The first two goals came in 4 minutes and 27 seconds — the fastest two-goal sequence.'),

  (v_league, v_rs, 'Which club won the Premier League by the largest points margin in history (19 points in 2017–18)?',
   '["Arsenal","Liverpool","Manchester United","Manchester City"]', 3, 'medium',
   'Manchester City won the 2017–18 Premier League by 19 points, finishing with 100 points to Manchester United''s 81 — the largest winning margin in the history of the competition.'),

  (v_league, v_rs, 'How many goals were needed per match on average to break 1,000 goals in the 2018–19 season?',
   '["2.4","2.6","2.8","3.0"]', 2, 'hard',
   'The 2018–19 Premier League season averaged 2.82 goals per game across 380 matches, the first time the competition broke the 1,000-goal barrier.'),

  (v_league, v_rs, 'Who scored the first ever Premier League hat-trick, netting four goals on the opening day in August 1992?',
   '["Alan Shearer","Eric Cantona","Mick Quinn","Paul Kitson"]', 2, 'hard',
   'Mick Quinn scored four goals for Coventry City against Middlesbrough on the opening day of the Premier League on 15 August 1992, making him the first player to score a hat-trick in the competition''s history.'),

  (v_league, v_rs, 'What is the record for most Premier League appearances at a single club?',
   '["534 (Ryan Giggs, Man Utd)","500 (Steven Gerrard, Liverpool)","572 (Gareth Barry, Aston Villa)","460 (Frank Lampard, Chelsea)"]', 0, 'hard',
   'Ryan Giggs made 534 Premier League appearances for Manchester United alone, though his total of 632 across all competitions for the club is the overall record.'),

  (v_league, v_rs, 'What percentage of Premier League managers are sacked before completing their first full season?',
   '["Around 20%","Around 35%","Around 50%","Around 65%"]', 2, 'hard',
   'Statistically, around half of all Premier League managers do not complete their first full season in charge, reflecting the high turnover rate in English top-flight management.'),

  (v_league, v_rs, 'Which player has scored the most Premier League goals for a single club?',
   '["Alan Shearer (Newcastle, 148)","Wayne Rooney (Man Utd, 183)","Sergio Agüero (Man City, 184)","Frank Lampard (Chelsea, 147)"]', 2, 'medium',
   'Sergio Agüero scored 184 Premier League goals for Manchester City, the most by any player for a single club in Premier League history.'),

  (v_league, v_rs, 'How many teams are relegated from the Premier League each season?',
   '["1","2","3","4"]', 2, 'easy',
   'Three teams are relegated from the Premier League each season: the bottom three in the table at the end of May drop down to the Championship.'),

  (v_league, v_rs, 'What is the most expensive Premier League transfer fee paid by a British club, set when Jack Grealish joined Man City in 2021?',
   '["£80m","£89m","£100m","£115m"]', 2, 'easy',
   'Jack Grealish became the first £100m British player when Manchester City signed him from Aston Villa in August 2021, breaking the record previously set by Harry Maguire.'),

  (v_league, v_rs, 'How many goals did Andrew Cole score in his Premier League career?',
   '["187","207","227","187"]', 1, 'hard',
   'Andrew Cole scored 187 Premier League goals in a career spanning Manchester United, Newcastle United, Blackburn Rovers and others — second only to Alan Shearer at the time of his retirement.'),

  (v_league, v_rs, 'Which season saw the Premier League expand to 20 clubs from the original 22?',
   '["1993–94","1994–95","1995–96","1997–98"]', 1, 'hard',
   'The Premier League reduced from 22 to 20 clubs ahead of the 1994–95 season. From 1995–96 onwards, 20 clubs have competed each year with 380 matches per season.'),

  (v_league, v_rs, 'Which stadium has the highest capacity in the Premier League?',
   '["Anfield","Emirates Stadium","Stamford Bridge","Old Trafford"]', 3, 'easy',
   'Old Trafford has a capacity of approximately 74,140, making it the largest club ground in the Premier League — though it will be surpassed when the new ground is built.'),

  (v_league, v_rs, 'Premier League clubs split the TV rights money. Roughly how much did the bottom club receive in 2022–23?',
   '["£40m","£60m","£80m","£100m"]', 2, 'hard',
   'In 2022–23, even the bottom-placed Premier League club received approximately £80m in TV revenue, illustrating why relegation is financially devastating and promotion is so valuable.'),

  (v_league, v_rs, 'How many goals did Erling Haaland score in his debut Premier League season (2022–23)?',
   '["30","33","36","38"]', 2, 'medium',
   'Erling Haaland scored 36 Premier League goals in his debut season for Manchester City in 2022–23, breaking the all-time single-season record previously held by Alan Shearer and Andrew Cole (34).'),

  (v_league, v_rs, 'Which club lost 29 of their 38 Premier League games in Derby County''s record-breaking worst season?',
   '["Sunderland in 2005–06","Derby County in 2007–08","Bradford City in 2000–01","Huddersfield in 2018–19"]', 1, 'easy',
   'Derby County''s 2007–08 season remains the worst in Premier League history: 1 win, 8 draws, 29 losses, 20 goals scored, 89 conceded, 11 points total.');

  -- ============================================================
  -- MANAGERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_mg, 'How many years did Sir Alex Ferguson manage Manchester United?',
   '["20","23","26","29"]', 2, 'easy',
   'Sir Alex Ferguson managed Manchester United from November 1986 to May 2013 — 26 years and 7 months — winning 13 Premier League titles, 5 FA Cups, and 2 Champions League trophies.'),

  (v_league, v_mg, 'Arsène Wenger managed Arsenal for how long?',
   '["18 years","20 years","22 years","24 years"]', 2, 'easy',
   'Arsène Wenger managed Arsenal from September 1996 to May 2018 — almost 22 years — transforming the club''s playing style, diet, and global appeal.'),

  (v_league, v_mg, 'José Mourinho described himself with which famous phrase at his Chelsea unveiling in 2004?',
   '["The Special Manager","The One and Only","The Special One","The Great Tactician"]', 2, 'easy',
   'José Mourinho called himself "The Special One" at his Chelsea unveiling in June 2004. His side won back-to-back Premier League titles in 2004–05 and 2005–06.'),

  (v_league, v_mg, 'Which manager led Blackburn Rovers to the Premier League title in 1994–95?',
   '["Howard Wilkinson","Kenny Dalglish","Jack Charlton","Bobby Robson"]', 1, 'medium',
   'Kenny Dalglish returned to management to lead Blackburn Rovers, backed by owner Jack Walker''s millions, to their only Premier League title in 1994–95.'),

  (v_league, v_mg, 'Which manager took over Liverpool in October 2015 and led them to six major trophies?',
   '["Brendan Rodgers","Rafael Benítez","Carlo Ancelotti","Jürgen Klopp"]', 3, 'easy',
   'Jürgen Klopp joined Liverpool in October 2015 and went on to win the Premier League, Champions League, FA Cup, League Cup, UEFA Super Cup, and Club World Cup.'),

  (v_league, v_mg, 'Who was the first manager to win the Premier League three seasons in succession?',
   '["Arsène Wenger","José Mourinho","Sir Alex Ferguson","Pep Guardiola"]', 2, 'medium',
   'Sir Alex Ferguson was the first manager to win three consecutive Premier League titles, doing so in 1998–99, 1999–2000, and 2000–01, and repeated the feat from 2006–09.'),

  (v_league, v_mg, 'Which legendary Liverpool manager famously said "if you are first you are first, if you are second you are nothing"?',
   '["Bob Paisley","Bill Shankly","Kenny Dalglish","Joe Fagan"]', 1, 'medium',
   'Bill Shankly built Liverpool into a top-flight power in the 1960s and 70s. His motivational quotes are still used in football today, and the gates at Anfield bear his name.'),

  (v_league, v_mg, 'Pep Guardiola joined Manchester City in which year?',
   '["2014","2015","2016","2017"]', 2, 'easy',
   'Pep Guardiola joined Manchester City in June 2016 from Bayern Munich and has gone on to become the most successful manager in the club''s history.'),

  (v_league, v_mg, 'Kevin Keegan managed Newcastle to near glory before resigning in January 1997. Which TV interview is he best remembered for?',
   '["His emotional resignation","The ''I would love it'' rant against Alex Ferguson","His post-match sing-along","His pre-game weather complaint"]', 1, 'medium',
   '"I would love it if we beat them — love it!" Kevin Keegan''s passionate Sky Sports outburst in April 1996 against Alex Ferguson''s comments is one of the most iconic moments in Premier League history.'),

  (v_league, v_mg, 'Claudio Ranieri managed which club to the greatest underdog story in Premier League history?',
   '["Hull City","Burnley","Leicester City","Swansea City"]', 2, 'easy',
   'Claudio Ranieri guided Leicester City to the 2015–16 Premier League title at odds of 5000/1. He had been seen as a "caretaker" type manager when appointed, making the achievement even more remarkable.'),

  (v_league, v_mg, 'Brian Clough is considered one of England''s greatest managers but never managed in the Premier League era. Which club did he take to European Cup glory twice?',
   '["Derby County","Nottingham Forest","Leeds United","Birmingham City"]', 1, 'medium',
   'Brian Clough won back-to-back European Cups with Nottingham Forest in 1979 and 1980 — one of the greatest managerial achievements in football history.'),

  (v_league, v_mg, 'Which manager won the Premier League title in his first season in charge in 2004–05?',
   '["Rafael Benítez","José Mourinho","Sam Allardyce","Martin O''Neill"]', 1, 'medium',
   'José Mourinho won the Premier League title in his first season at Chelsea in 2004–05 with a record 95 points, breaking numerous defensive records.'),

  (v_league, v_mg, 'Who managed Manchester City to their first Premier League title in 2011–12?',
   '["Mark Hughes","Roberto Mancini","Manuel Pellegrini","Brian Kidd"]', 1, 'medium',
   'Roberto Mancini guided Manchester City to their first Premier League title in May 2012, dramatically secured on goal difference over Manchester United on the final day.'),

  (v_league, v_mg, 'Which manager famously refused to shake José Mourinho''s hand after a match?',
   '["Rafael Benítez","Arsène Wenger","Sam Allardyce","David Moyes"]', 1, 'hard',
   'Arsène Wenger and José Mourinho had a famously frosty relationship, with Wenger once calling Mourinho a "specialist in failure." They had several high-profile touchline confrontations.'),

  (v_league, v_mg, 'Harry Redknapp was nicknamed "''Arry" and is known for managing which clubs in the Premier League?',
   '["West Ham, Portsmouth, Spurs","Southampton, Spurs, Arsenal","Fulham, Chelsea, Arsenal","QPR only"]', 0, 'medium',
   'Harry Redknapp managed West Ham, Southampton, Portsmouth, Tottenham, and Queens Park Rangers during his Premier League career, famously doing media in his car outside his house.'),

  (v_league, v_mg, 'In which year did David Moyes replace Sir Alex Ferguson as Manchester United manager?',
   '["2012","2013","2014","2015"]', 1, 'easy',
   'David Moyes was appointed Manchester United manager in June 2013 after Ferguson''s retirement, having been personally recommended by Ferguson. He lasted just 10 months.'),

  (v_league, v_mg, 'Which manager won five Premier League titles in six seasons, from 2011–12 to 2018–19?',
   '["Pep Guardiola","José Mourinho","Jürgen Klopp","Louis van Gaal"]', 0, 'hard',
   'Pep Guardiola won 5 Premier League titles in 8 seasons at Manchester City (2017–18, 2018–19, 2020–21, 2021–22, 2022–23), more than any other manager in the competition.'),

  (v_league, v_mg, 'Which club have had the most managers in the Premier League era?',
   '["Leicester City","Watford","Sunderland","Bolton Wanderers"]', 1, 'hard',
   'Watford are known for frequently changing managers — they had 16 different managers during their time in the Premier League across multiple spells, more than any other club.'),

  (v_league, v_mg, 'Who was the first foreign manager to win the Premier League title?',
   '["Arsène Wenger","Claudio Ranieri","Carlo Ancelotti","José Mourinho"]', 0, 'medium',
   'Arsène Wenger became the first foreign manager to win the Premier League title in 1997–98 with Arsenal, heralding a new era of continental influence in English football.'),

  (v_league, v_mg, 'Gerard Houllier managed Liverpool from 1998 to 2004. Which country is he from?',
   '["Belgium","France","Spain","Italy"]', 1, 'medium',
   'Gerard Houllier is French and managed Liverpool to the famous 2000–01 cup treble (League Cup, FA Cup, UEFA Cup), establishing them as a competitive force again.'),

  (v_league, v_mg, 'Which manager guided Leicester City to their impossible Premier League title?',
   '["Nigel Pearson","Claudio Ranieri","Michel Preud''homme","Craig Shakespeare"]', 1, 'easy',
   'Claudio Ranieri had been out of management after being sacked by Greece before joining Leicester. His calm, measured approach and the famous "dilly ding, dilly dong" bell became iconic.'),

  (v_league, v_mg, 'Who is the only manager to win the Premier League with two different clubs?',
   '["José Mourinho","Pep Guardiola","Manuel Pellegrini","No manager has done this"]', 3, 'hard',
   'No manager has won the Premier League with two different clubs. The feat has been achieved in European competitions but not in the Premier League itself.'),

  (v_league, v_mg, 'Which manager is credited with introducing sports science, dietary changes, and squad rotation to English football at Arsenal?',
   '["George Graham","Terry Venables","Arsène Wenger","Don Howe"]', 2, 'easy',
   'Arsène Wenger revolutionised English football when he arrived at Arsenal in 1996, introducing continental training methods, dietary restrictions (no more chips!), and a new style of passing football.'),

  (v_league, v_mg, 'Tony Pulis is famous for managing lower-budget clubs and achieving what?',
   '["Winning the Premier League with Stoke","Keeping clubs in the Premier League against the odds","Setting a goals-per-game record","Winning three consecutive League Cups"]', 1, 'medium',
   'Tony Pulis became famous for his pragmatic style and keeping clubs like Stoke City, West Bromwich Albion, and Crystal Palace in the Premier League through organisation and set-piece routines.'),

  (v_league, v_mg, 'Which manager famously said "we''re not a big club" while managing Tottenham Hotspur?',
   '["Harry Redknapp","André Villas-Boas","Juande Ramos","Tim Sherwood"]', 2, 'hard',
   'Various Tottenham managers have downplayed the club''s status over the years, but André Villas-Boas''s pragmatic approach at Spurs was often questioned by fans expecting a more ambitious outlook.'),

  (v_league, v_mg, 'Sam Allardyce was appointed England national team manager in 2016 but resigned after how many games?',
   '["1","2","3","4"]', 0, 'medium',
   'Sam Allardyce resigned as England manager after just one match — a 1–0 win over Slovakia — following a newspaper sting that captured him allegedly offering advice on circumventing FA rules.'),

  (v_league, v_mg, 'Which former Tottenham manager is also a qualified physiotherapist and was known for his innovative training methods?',
   '["Glenn Hoddle","Ossie Ardiles","Juande Ramos","Christian Gross"]', 0, 'hard',
   'Glenn Hoddle had the FA coaching badge and believed in various alternative methods including faith healer Eileen Drewery. He managed Tottenham from 2001 to 2003.'),

  (v_league, v_mg, 'Which manager took charge of Chelsea, Manchester United, and Tottenham in the Premier League era?',
   '["Carlo Ancelotti","Claudio Ranieri","José Mourinho","Rafael Benítez"]', 2, 'easy',
   'José Mourinho managed Chelsea (twice: 2004–07 and 2013–15), Manchester United (2016–18), and Tottenham Hotspur (2019–21) — three of the Premier League''s top clubs.'),

  (v_league, v_mg, 'Who was the first manager to win four Premier League titles?',
   '["Pep Guardiola","Sir Alex Ferguson","José Mourinho","Arsène Wenger"]', 1, 'medium',
   'Sir Alex Ferguson won his fourth Premier League title in 2002–03 — the first manager to achieve four — and went on to win 13 in total.'),

  (v_league, v_mg, 'Rafael Benítez managed Newcastle United in 2016–19 after relegation. He is best known for managing which club to the Champions League in 2005?',
   '["Valencia","Inter Milan","Liverpool","Napoli"]', 2, 'easy',
   'Rafael Benítez managed Liverpool to the Champions League title in 2005, orchestrating the Miracle of Istanbul comeback against AC Milan. He is highly regarded as one of the best tactical managers of his generation.'),

  (v_league, v_mg, 'Ole Gunnar Solskjær managed Manchester United from December 2018 to November 2021. Which country is he from?',
   '["Sweden","Denmark","Norway","Finland"]', 2, 'easy',
   'Ole Gunnar Solskjær is Norwegian and scored the winning goal for Manchester United in the 1999 Champions League Final. As manager, he helped revive the club''s performance before ultimately being sacked.');

  -- ============================================================
  -- TRANSFERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_tr, 'Alan Shearer joined Newcastle United from Blackburn Rovers in 1996 for a then world record fee. How much was it?',
   '["£12m","£15m","£18m","£22m"]', 1, 'medium',
   'Alan Shearer joined his hometown club Newcastle United for a then world record £15 million in July 1996, a fee that wasn''t surpassed in British football for several years.'),

  (v_league, v_tr, 'Jack Grealish became the first £100m British player when he joined which club in 2021?',
   '["Liverpool","Arsenal","Chelsea","Manchester City"]', 3, 'easy',
   'Jack Grealish moved from Aston Villa to Manchester City for £100 million in August 2021, becoming the most expensive British transfer ever at the time.'),

  (v_league, v_tr, 'Rio Ferdinand moved from Leeds United to Manchester United in 2002 for how much?',
   '["£22m","£26m","£30m","£34m"]', 2, 'medium',
   'Rio Ferdinand moved for £30 million in July 2002, a then British record. He went on to win five Premier League titles and the Champions League with Manchester United.'),

  (v_league, v_tr, 'Wayne Rooney left Everton for Manchester United in 2004 for approximately how much?',
   '["£20m","£25.6m","£30m","£35m"]', 1, 'medium',
   'Wayne Rooney moved from Everton to Manchester United for £25.6 million in August 2004, aged just 18, and went on to become United''s all-time top scorer.'),

  (v_league, v_tr, 'Virgil van Dijk joined Liverpool in January 2018 for a then world record fee for a defender. What was the fee?',
   '["£55m","£65m","£75m","£85m"]', 2, 'medium',
   'Liverpool paid Southampton £75 million for Virgil van Dijk in January 2018, a world record for a defender at the time. His influence helped Liverpool win the Champions League and Premier League.'),

  (v_league, v_tr, 'Robinho was the first player signed after the Abu Dhabi takeover of Manchester City in 2008. What was the approximate fee?',
   '["£22m","£28m","£32.5m","£40m"]', 2, 'medium',
   'Robinho joined Manchester City from Real Madrid for £32.5 million on the same day the Abu Dhabi United Group completed their takeover — a statement of intent.'),

  (v_league, v_tr, 'Kevin De Bruyne joined Manchester City from which club in 2015?',
   '["Chelsea","Bayer Leverkusen","Wolfsburg","VfL Bochum"]', 2, 'medium',
   'Kevin De Bruyne joined Manchester City from Wolfsburg for approximately £54 million in August 2015, having been let go by Chelsea two years earlier without making his mark there.'),

  (v_league, v_tr, 'Manchester United paid a world record fee for a defender when they signed Harry Maguire in 2019. How much did they pay?',
   '["£60m","£70m","£80m","£90m"]', 2, 'medium',
   'Manchester United paid Leicester City £80 million for Harry Maguire in August 2019, then a world record for a defender. The fee drew significant criticism when his form declined after an early impressive period.'),

  (v_league, v_tr, 'Which striker became the first player to cost more than £100m when he moved from Liverpool to Barcelona in 2014?',
   '["Fernando Torres","Luis Suárez","Philippe Coutinho","Raheem Sterling"]', 1, 'medium',
   'Luis Suárez moved from Liverpool to Barcelona for approximately £65 million in 2014, not over £100m. Philippe Coutinho''s move to Barca in 2018 for £142m is the British record outgoing.'),

  (v_league, v_tr, 'Fernando Torres joined Chelsea from Liverpool in January 2011 for a then British record fee. How much was it?',
   '["£40m","£45m","£50m","£55m"]', 2, 'medium',
   'Fernando Torres joined Chelsea from Liverpool for £50 million in January 2011, breaking the British transfer record at the time. However, he struggled to replicate his Liverpool form at Stamford Bridge.'),

  (v_league, v_tr, 'Raheem Sterling left Liverpool for Manchester City in 2015. What was the approximate fee?',
   '["£39m","£44m","£49m","£55m"]', 2, 'medium',
   'Raheem Sterling moved from Liverpool to Manchester City for approximately £49 million in July 2015, a controversial move that drew criticism from some Liverpool fans.'),

  (v_league, v_tr, 'Which French striker joined Arsenal from Juventus in 1999 in one of the greatest bargain transfers in Premier League history?',
   '["Thierry Henry","Nicolas Anelka","Davor Šuker","Nwankwo Kanu"]', 0, 'hard',
   'Thierry Henry joined Arsenal from Juventus for just £10.5 million in August 1999. Arsène Wenger converted him from a winger to a centre-forward, and he went on to become the Premier League''s fourth all-time top scorer.'),

  (v_league, v_tr, 'Which player''s move from Manchester City to Barcelona in 2023 included a buyback clause?',
   '["Phil Foden","Jack Grealish","Bernardo Silva","Oleksandr Zinchenko"]', 2, 'hard',
   'Bernardo Silva was linked with Barcelona multiple times. However, several City sales, like Leroy Sané''s move to Bayern Munich in 2020 for €45m, shaped modern Premier League transfer history.'),

  (v_league, v_tr, 'Cristiano Ronaldo''s first spell at Manchester United ended with a move to Real Madrid in 2009 for how much?',
   '["£60m","£70m","£80m","£90m"]', 2, 'medium',
   'Cristiano Ronaldo joined Real Madrid from Manchester United for £80 million in June 2009, setting a then world record transfer fee. He had won 3 Premier League titles and the Champions League with United.'),

  (v_league, v_tr, 'Which German goalkeeper did Arsenal sign from Bayer Leverkusen in 2018 to become their long-term number one?',
   '["Jack Butland","Bernd Leno","Petr Čech","Kasper Schmeichel"]', 1, 'hard',
   'Bernd Leno joined Arsenal from Bayer Leverkusen for approximately £19 million in June 2018. He was the first-choice keeper at the Emirates until being displaced by Aaron Ramsdale, whom Arsenal signed in 2021.'),

  (v_league, v_tr, 'The transfer of Gareth Bale from Tottenham to Real Madrid in 2013 set a then world record. How much was it?',
   '["£65m","£75m","£85m","£95m"]', 2, 'medium',
   'Gareth Bale moved from Tottenham to Real Madrid for £85 million in September 2013, breaking the world transfer record previously set by Cristiano Ronaldo''s own move to Madrid.'),

  (v_league, v_tr, 'Which striker joined Chelsea from Atletico Madrid in 2011 for £50.7m, making him the most expensive British signing at the time?',
   '["Diego Forlán","David Villa","Radamel Falcao","Fernando Torres"]', 3, 'easy',
   'Fernando Torres'' move from Liverpool to Chelsea for £50 million was a British record in January 2011. Despite a slow start, he did win the FA Cup and Champions League with Chelsea.'),

  (v_league, v_tr, 'Arsenal''s record signing as of 2023 is which player, signed for £105m from Manchester City?',
   '["Declan Rice","Kai Havertz","Leandro Trossard","Jakub Kiwior"]', 0, 'medium',
   'Declan Rice joined Arsenal from West Ham United for £105 million in July 2023, making him Arsenal''s and one of English football''s most expensive transfers ever.'),

  (v_league, v_tr, 'Manchester United signed which Dutch midfielder from PSV Eindhoven in 1995, transforming their midfield?',
   '["Marc Overmars","Jaap Stam","Ruud van Nistelrooy","Roy Keane"]', 0, 'hard',
   'While Marc Overmars went to Arsenal from Ajax, Manchester United''s big Dutch signing was Jaap Stam in 1998 for £10.75m from PSV. In 1995, United signed Andy Cole and Eric Cantona extended his stay.'),

  (v_league, v_tr, 'Philippe Coutinho left Liverpool for Barcelona in January 2018. What was the fee, making it the most expensive British outgoing transfer?',
   '["£97m","£118m","£142m","£155m"]', 2, 'medium',
   'Philippe Coutinho joined Barcelona for an initial £105m rising to £142m with add-ons in January 2018, making it the most expensive departure of a player from a British club.'),

  (v_league, v_tr, 'Which club broke the British transfer record when they signed Didier Drogba from Marseille in 2004?',
   '["Arsenal","Liverpool","Chelsea","Tottenham"]', 2, 'medium',
   'Chelsea signed Didier Drogba from Olympique de Marseille for £24 million in July 2004. He went on to score 164 goals in 381 appearances, becoming a Stamford Bridge legend.'),

  (v_league, v_tr, 'Neymar''s world record transfer from Barcelona to PSG in 2017 for £198m had a ripple effect. Which club used some of that money to sign who?',
   '["Arsenal signed Lacazette","Liverpool signed Salah","Barcelona signed Dembélé","Man City signed Walker"]', 2, 'medium',
   'Barcelona used the Neymar money to sign Ousmane Dembélé from Borussia Dortmund for £96.8m and Philippe Coutinho from Liverpool. This freed up Coutinho money for Liverpool to sign Mohamed Salah.'),

  (v_league, v_tr, 'Which legendary Frenchman left Arsenal to join Barcelona in 2008?',
   '["Robert Pires","Thierry Henry","Sylvain Wiltord","Patrick Vieira"]', 1, 'medium',
   'Thierry Henry left Arsenal for Barcelona in June 2008 for £16.1 million, ending a nine-year association with the club. He later returned on loan to Arsenal in January 2012.'),

  (v_league, v_tr, 'Robinho was the first of the "new wave" of signings under which Abu Dhabi-owned club''s regime?',
   '["Chelsea","Manchester City","Newcastle United","Aston Villa"]', 1, 'easy',
   'The Abu Dhabi United Group, led by Sheikh Mansour, completed the takeover of Manchester City in September 2008 and immediately signed Robinho as a statement of intent.'),

  (v_league, v_tr, 'Which English club sold Cristiano Ronaldo twice — in 2009 and again on his return?',
   '["Arsenal","Chelsea","Manchester United","Tottenham"]', 2, 'easy',
   'Manchester United sold Ronaldo to Real Madrid for £80m in 2009, then re-signed him for £12.85m in 2021, only to mutually terminate his contract in November 2022.'),

  (v_league, v_tr, 'In which year did Chelsea first break the £30m transfer barrier, signing John Terry on a new contract?',
   '["This never happened — Terry was home-grown","2002","2005","2008"]', 0, 'hard',
   'John Terry came through Chelsea''s youth academy and never required a transfer fee. Chelsea''s actual £30m+ barrier was Rio Ferdinand''s move to Man Utd — Chelsea''s own breaking of that mark was Shevchenko in 2006 (£30m+).'),

  (v_league, v_tr, 'Which Nigerian striker joined Arsenal from Inter Milan on loan in 1999 and impressed enough to sign permanently?',
   '["Jay-Jay Okocha","Kanu","Victor Moses","Efan Ekoku"]', 1, 'medium',
   'Nwankwo Kanu joined Arsenal on loan from Inter Milan in 1999 after a successful career at Ajax. He scored some memorable goals, including a famous hat-trick against Chelsea from 3–0 down.'),

  (v_league, v_tr, 'Kyle Walker became one of the most expensive defenders in history when he left Tottenham for Manchester City in 2017. What was the approximate fee?',
   '["£35m","£45m","£55m","£65m"]', 1, 'medium',
   'Kyle Walker joined Manchester City from Tottenham Hotspur for approximately £45 million in July 2017 — a fee that seemed extraordinary for a right-back but proved excellent value as he won multiple Premier League titles.'),

  (v_league, v_tr, 'Which transfer moved Romelu Lukaku from Everton to Manchester United in 2017?',
   '["£65m","£75m","£85m","£95m"]', 1, 'medium',
   'Romelu Lukaku joined Manchester United from Everton for £75 million in July 2017, at the time the most expensive Belgian player in history.'),

  (v_league, v_tr, 'Mo Salah''s second arrival at Liverpool (2017) from which club proved to be one of the best signings in Premier League history?',
   '["Juventus","Barcelona","AS Roma","Fiorentina"]', 2, 'easy',
   'Mohamed Salah joined Liverpool from AS Roma for £34.3 million in June 2017. He went on to break the Premier League single-season scoring record with 32 goals in 2017–18.'),

  (v_league, v_tr, 'Which club famously signed Robbie Keane for £19m only to sell him back to Spurs six months later for a £7m loss?',
   '["Arsenal","Manchester United","Liverpool","Chelsea"]', 2, 'hard',
   'Liverpool signed Robbie Keane from Tottenham for £19m in July 2008 but sold him back to Spurs for £12m in February 2009 — one of the most embarrassing transfers in Premier League history.');

  -- ============================================================
  -- STADIUM & CULTURE (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_sc, 'What is the approximate capacity of Old Trafford, the home of Manchester United?',
   '["67,000","70,000","74,140","80,000"]', 2, 'easy',
   'Old Trafford''s current capacity is approximately 74,140, making it the largest club football ground in the UK. Plans for a major redevelopment could increase this to over 86,000.'),

  (v_league, v_sc, 'Liverpool''s anthem "You''ll Never Walk Alone" was originally a song from which musical?',
   '["Oklahoma!","South Pacific","Carousel","Annie Get Your Gun"]', 2, 'easy',
   '"You''ll Never Walk Alone" was written by Rodgers and Hammerstein for the 1945 musical Carousel. It was adopted by Gerry and the Pacemakers and Liverpool fans in 1963.'),

  (v_league, v_sc, 'What is the famous terrace at Anfield that houses Liverpool''s most vocal supporters?',
   '["The North Stand","The Kop","The Centenary Stand","The Sir Kenny Dalglish Stand"]', 1, 'easy',
   'The Spion Kop at Anfield is the largest single-tier terrace in the UK, with a capacity of 12,390. The name derives from the Battle of Spion Kop in the Boer War.'),

  (v_league, v_sc, 'Arsenal left Highbury to move into the Emirates Stadium in which year?',
   '["2004","2005","2006","2007"]', 2, 'easy',
   'Arsenal moved into the 60,000-seat Emirates Stadium in 2006, naming rights sold to Emirates airline for £100m over 15 years. They had played at Highbury since 1913.'),

  (v_league, v_sc, 'Tottenham Hotspur''s new stadium opened in 2019. What is its capacity?',
   '["55,000","57,000","60,000","62,062"]', 3, 'medium',
   'Tottenham Hotspur Stadium has a capacity of 62,062, making it the largest football stadium in London. It also features an NFL field, retractable pitch, and a sky walk.'),

  (v_league, v_sc, 'Manchester City''s Etihad Stadium was originally built for which event?',
   '["1996 Olympics (bid)","1996 European Championships","2002 Commonwealth Games","2003 FA Cup Final"]', 2, 'medium',
   'The City of Manchester Stadium (now Etihad Stadium) was built for the 2002 Commonwealth Games. Manchester City moved in for the 2003–04 season after it was converted for football use.'),

  (v_league, v_sc, 'Chelsea''s home ground Stamford Bridge opened in which decade?',
   '["1870s","1880s","1890s","1900s"]', 2, 'medium',
   'Stamford Bridge was opened in April 1877 as an athletics ground and was one of the earliest major sporting venues in London, predating Chelsea FC itself by 28 years.'),

  (v_league, v_sc, 'Newcastle United play at which ground?',
   '["St James'' Park","Gallowgate Ground","Tyne Stadium","Blaydon Park"]', 0, 'easy',
   'Newcastle United have played at St James'' Park since 1892. The ground is situated in the heart of the city and is a visible landmark, with a capacity of approximately 52,305.'),

  (v_league, v_sc, 'The phrase "Football''s Coming Home" comes from which famous song?',
   '["Three Lions","World in Motion","Stand Up If You Hate Man U","Football Is"]', 0, 'medium',
   '"Three Lions" by Lightning Seeds, written with comedians Frank Skinner and David Baddiel, was released for Euro 1996 hosted in England. It became an anthem re-released at every subsequent major tournament.'),

  (v_league, v_sc, 'What nickname do fans use to refer to the rivalry between Arsenal and Tottenham?',
   '["The Battle of London","El Clásico del Norte","The North London Derby","The Capital Cup"]', 2, 'easy',
   'The North London Derby between Arsenal and Tottenham is one of the most intense rivalries in English football, dating back to the early 20th century. Arsenal moved to north London in 1913, directly into Spurs'' territory.'),

  (v_league, v_sc, 'What is the name of Liverpool''s famous cup double with local rivals Everton?',
   '["The Derby Cup","The Mersey Derby","The Stanley Cup","The Stanley Derby"]', 1, 'easy',
   'The Merseyside Derby between Liverpool and Everton is one of the oldest local rivalries in football, with Everton originally based at Anfield before moving to Goodison Park in 1892.'),

  (v_league, v_sc, 'The "Theatre of Dreams" is a nickname for which ground?',
   '["Anfield","Stamford Bridge","Old Trafford","The Emirates"]', 2, 'easy',
   'Old Trafford was nicknamed "The Theatre of Dreams" by Sir Bobby Charlton. The name reflects the stadium''s history of producing magical moments in European football.'),

  (v_league, v_sc, 'Which pub near Wembley Stadium is famous as a Premier League and football cultural institution?',
   '["The Three Lions","The Green Man","The Torch","Boxpark Wembley"]', 3, 'hard',
   'Boxpark Wembley has become the go-to destination for Premier League fans before and after matches at the national stadium, though many traditional pubs around Wembley also carry historic significance.'),

  (v_league, v_sc, 'What is the name of the rivalry between Manchester United and Manchester City?',
   '["The Northwest Derby","The Manchester Derby","The Mancunian Derby","The Red-Blue Derby"]', 1, 'easy',
   'The Manchester Derby between United and City is one of the Premier League''s biggest fixtures. Since City''s Abu Dhabi-backed revival, both teams have competed for the title regularly, intensifying the rivalry.'),

  (v_league, v_sc, 'Goodison Park, home of Everton, is in which area of Liverpool?',
   '["Toxeth","Walton","Kirkdale","Anfield"]', 1, 'medium',
   'Goodison Park is located in Walton, Liverpool. Everton moved there in 1892 after a dispute over rent at Anfield and have played there for over 130 years.'),

  (v_league, v_sc, 'What is the yellow-and-green scarf worn by some Manchester United fans symbolic of?',
   '["Away kit colours","The original Newton Heath colours","Club founding colours","A protest against the Glazer ownership"]', 3, 'medium',
   'The yellow and green scarf is worn as a protest against the Glazer family''s ownership of Manchester United. Green and gold are the original Newton Heath colours and have become a symbol of fan resistance.'),

  (v_league, v_sc, 'Which Premier League club''s fans are known as "Gooners"?',
   '["Tottenham Hotspur","Arsenal","Millwall","West Ham"]', 1, 'easy',
   '"Gooners" is the nickname for Arsenal fans, derived from the club''s nickname "The Gunners." The club''s crest features a cannon, referencing their Woolwich Arsenal origins.'),

  (v_league, v_sc, 'The "Prawn Sandwich Brigade" is a term coined by which footballer to describe corporate Premier League fans?',
   '["Eric Cantona","Roy Keane","Patrick Vieira","Tony Adams"]', 1, 'medium',
   'Roy Keane memorably referred to some Manchester United fans as the "Prawn Sandwich Brigade" in 2000, criticising those who consumed hospitality food rather than creating a loud atmosphere.'),

  (v_league, v_sc, 'Which Liverpool manager famously installed the "This is Anfield" sign above the players'' tunnel?',
   '["Jürgen Klopp","Bob Paisley","Kenny Dalglish","Bill Shankly"]', 3, 'medium',
   'Bill Shankly had the "This is Anfield" sign installed to intimidate visiting teams, reminding them of the fortress they were entering. The players touch it as a ritual before every match.'),

  (v_league, v_sc, 'What is the nickname of West Ham United?',
   '["The Hammers","The Irons","Both of these","Neither of these"]', 2, 'easy',
   'West Ham United are known as both "The Hammers" and "The Irons," referring to their founding as Thames Ironworks FC. Their crest features crossed riveting hammers.'),

  (v_league, v_sc, 'Which Premier League ground is nicknamed "The Amex"?',
   '["Bristol City Stadium","Burnley''s Turf Moor","Brighton''s Falmer Stadium","Bournemouth''s Vitality Stadium"]', 2, 'medium',
   'Brighton & Hove Albion''s Falmer Stadium is nicknamed "The Amex" after its naming rights sponsor, the American Express Community Stadium opened in 2011.'),

  (v_league, v_sc, 'What colour do Arsenal traditionally wear at home?',
   '["Blue and white","All white","Red and white","Yellow and blue"]', 2, 'easy',
   'Arsenal''s traditional home kit is red shirts with white sleeves — a kit introduced by Herbert Chapman in the 1930s, inspired by Nottingham Forest''s strip.'),

  (v_league, v_sc, 'Which three-word phrase defines Man City''s revival since the Abu Dhabi takeover?',
   '["Blue Moon Rising","City of Manchester","The Noisy Neighbours","The New Normal"]', 2, 'medium',
   'Sir Alex Ferguson famously called Manchester City "the noisy neighbours" after their takeover, dismissing their early ambitions. The phrase stuck as they grew to become the dominant force in English football.'),

  (v_league, v_sc, 'The Hillsborough disaster in 1989 led to sweeping safety changes. At which ground did it occur?',
   '["Old Trafford","Villa Park","Hillsborough, Sheffield","Wembley"]', 2, 'easy',
   'The Hillsborough disaster occurred on 15 April 1989 at Sheffield Wednesday''s ground during an FA Cup semi-final between Liverpool and Nottingham Forest, claiming the lives of 97 Liverpool supporters.'),

  (v_league, v_sc, 'The Taylor Report (1990) following Hillsborough led to which major change in English football grounds?',
   '["Banning away fans","Introducing video replays","All-seater stadiums for top-flight clubs","Reducing stadium capacities by 10%"]', 2, 'easy',
   'The Taylor Report recommended that all top-flight English grounds become all-seater, fundamentally changing the atmosphere and culture at English football matches from the terracing era.'),

  (v_league, v_sc, 'Wembley Stadium''s famous twin towers were replaced when the new stadium opened in which year?',
   '["2005","2006","2007","2008"]', 2, 'easy',
   'The new Wembley Stadium opened in March 2007, replacing the famous old Wembley with its twin towers. The new stadium features a distinctive arch and has a capacity of 90,000.'),

  (v_league, v_sc, 'What colour is Everton''s home shirt?',
   '["Red","Blue","White","Black"]', 1, 'easy',
   'Everton play in royal blue home shirts, earning them the nickname "The Toffees." They are one of only two Merseyside clubs in the Premier League alongside Liverpool.'),

  (v_league, v_sc, 'Which Premier League club''s badge features a red rose?',
   '["Burnley","Preston North End","Blackburn Rovers","Bolton Wanderers"]', 0, 'medium',
   'Burnley''s badge features a bee and a lion, while Lancashire''s red rose appears on several Lancashire clubs'' badges including Burnley, Preston and Blackburn — but Burnley''s badge most prominently features it.'),

  (v_league, v_sc, 'What does the Latin phrase "Nil Satis Nisi Optimum" (Everton''s motto) mean?',
   '["Nothing is too good for us","Nothing but the best is good enough","Always strive for more","Play with honour"]', 1, 'medium',
   'Everton''s Latin motto "Nil Satis Nisi Optimum" translates as "Nothing but the best is good enough." It reflects the club''s aspirational identity, though their recent history has tested that philosophy.'),

  (v_league, v_sc, 'Liverpool''s famous red home kit was introduced under which manager in the 1960s?',
   '["Bob Paisley","Joe Fagan","Bill Shankly","Don Welsh"]', 2, 'medium',
   'Bill Shankly introduced Liverpool''s all-red home kit in 1964, reportedly inspired by the psychological advantage of a uniform colour. The kit has remained a symbol of the club ever since.');

end;
$$;
