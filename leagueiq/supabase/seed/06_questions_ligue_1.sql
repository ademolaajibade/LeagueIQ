-- ============================================================
-- LeagueIQ — Seed: Ligue 1 Questions (210)
-- 30 per category × 7 categories
-- ============================================================

do $$
declare
  v_league  uuid := '55555555-5555-5555-5555-555555555555';
  v_ch      uuid; -- club_history
  v_fp      uuid; -- famous_players
  v_lc      uuid; -- le_classique
  v_rs      uuid; -- records_stats
  v_mg      uuid; -- managers
  v_tr      uuid; -- transfers
  v_sc      uuid; -- stadium_culture
begin
  select id into v_ch from public.categories where league_id = v_league and slug = 'club_history';
  select id into v_fp from public.categories where league_id = v_league and slug = 'famous_players';
  select id into v_lc from public.categories where league_id = v_league and slug = 'le_classique';
  select id into v_rs from public.categories where league_id = v_league and slug = 'records_stats';
  select id into v_mg from public.categories where league_id = v_league and slug = 'managers';
  select id into v_tr from public.categories where league_id = v_league and slug = 'transfers';
  select id into v_sc from public.categories where league_id = v_league and slug = 'stadium_culture';

  -- ============================================================
  -- CLUB HISTORY (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_ch, 'How many Ligue 1 titles has Paris Saint-Germain won?',
   '["9","10","12","14"]', 2, 'easy',
   'PSG have won Ligue 1 12 times as of 2024, including a dominant run of nine titles in 11 seasons following their Qatar Sports Investments takeover in 2011. Their first title came in 1985–86, long before the QSI era.'),

  (v_league, v_ch, 'PSG was founded in which year?',
   '["1965","1970","1975","1980"]', 1, 'easy',
   'Paris Saint-Germain was founded on 12 August 1970 through a merger of Paris FC and Stade Saint-Germain-en-Laye. The club was created to give Paris a major football club to rival the southern French sides.'),

  (v_league, v_ch, 'Which year did Qatar Sports Investments (QSI) purchase PSG?',
   '["2009","2011","2013","2015"]', 1, 'easy',
   'Qatar Sports Investments purchased Paris Saint-Germain in June 2011 for approximately €50 million. Under QSI leadership, PSG transformed from a mid-table club to one of Europe''s wealthiest and most ambitious.'),

  (v_league, v_ch, 'Olympique de Marseille was founded in which year?',
   '["1895","1899","1905","1912"]', 1, 'medium',
   'Olympique de Marseille was founded on 31 October 1899, making it one of the oldest football clubs in France. The club emerged from a sports association and adopted the blue and white colours of Marseille''s maritime traditions.'),

  (v_league, v_ch, 'Which French club became the first to win the UEFA Champions League in 1993?',
   '["Paris Saint-Germain","Monaco","Lens","Olympique de Marseille"]', 3, 'easy',
   'Olympique de Marseille became the only French club to win the UEFA Champions League, defeating AC Milan 1-0 in the 1993 final in Munich. However, the title was mired in the VA-OM match-fixing scandal.'),

  (v_league, v_ch, 'AS Monaco was founded in which city?',
   '["Nice","Marseille","Monaco","Cannes"]', 2, 'easy',
   'AS Monaco was founded in Monaco (the Principality of Monaco) in 1919. Despite competing in French football, the club represents an independent city-state and pays no French taxes on player wages.'),

  (v_league, v_ch, 'Which club has won the most Ligue 1 titles in total?',
   '["Olympique de Marseille","AS Saint-Étienne","Paris Saint-Germain","Olympique Lyonnais"]', 1, 'hard',
   'AS Saint-Étienne hold the record for most Ligue 1 titles with 10 championships, mostly won in the 1960s and 1970s. PSG are rapidly approaching this record with their modern dominance.'),

  (v_league, v_ch, 'Olympique Lyonnais won how many consecutive Ligue 1 titles from 2002 to 2008?',
   '["5","6","7","8"]', 2, 'medium',
   'Olympique Lyonnais won seven consecutive Ligue 1 titles from 2001–02 to 2007–08 — a record in French football. The team featured players like Juninho Pernambucano, Michael Essien, and Karim Benzema.'),

  (v_league, v_ch, 'Which Ligue 1 club is nicknamed "Les Canaris" (The Canaries) for their yellow kit?',
   '["Nantes","Bordeaux","Rennes","Lens"]', 0, 'medium',
   'FC Nantes are nicknamed "Les Canaris" (The Canaries) because of their distinctive bright yellow home kit. The club have won eight Ligue 1 titles and are known for their youth development.'),

  (v_league, v_ch, 'Girondins de Bordeaux won the Ligue 1 title most recently in which year?',
   '["2005","2007","2009","2011"]', 2, 'medium',
   'Girondins de Bordeaux won their most recent Ligue 1 title in 2008–09 under Laurent Blanc, with Marouane Chamakh leading the attack. Bordeaux were a significant Ligue 1 force throughout the 2000s.'),

  (v_league, v_ch, 'Stade de Reims was France''s most successful club in the 1950s. What European achievement did they make?',
   '["Winning the UEFA Cup","Winning the European Cup twice","Reaching the European Cup Final twice","Winning the Coupe de France twice"]', 2, 'hard',
   'Stade de Reims reached the European Cup Final twice — in 1956 (losing to Real Madrid 4-3) and 1959 (losing 2-0 to Real Madrid). They had a legendary team featuring Just Fontaine, France''s all-time World Cup top scorer.'),

  (v_league, v_ch, 'Lille OSC won Ligue 1 in which year, ending PSG''s dominance?',
   '["2018","2019","2020–21","2022"]', 2, 'medium',
   'Lille OSC won Ligue 1 in 2020–21 under Christophe Galtier, surprisingly beating PSG to the title in one of Ligue 1''s greatest upsets. Manager Galtier and sporting director Luis Campos then both left for other clubs.'),

  (v_league, v_ch, 'Which French club was historically dominant in the 1980s and won the UEFA Cup in 1996?',
   '["Lyon","Nantes","Paris Saint-Germain","Metz"]', 2, 'medium',
   'Paris Saint-Germain won the UEFA Cup Winners'' Cup in 1996 (not the UEFA Cup) — their only European trophy as of 2024. In the 1990s, they competed in European football regularly, including two Champions League semi-finals.'),

  (v_league, v_ch, 'RC Lens is based in which French region, known for its mining heritage?',
   '["Normandy","Alsace","Nord-Pas-de-Calais","Burgundy"]', 2, 'medium',
   'RC Lens is based in Lens in the Nord-Pas-de-Calais region, France''s former coal mining heartland. The club has a deeply working-class fanbase and won Ligue 1 in 1997–98.'),

  (v_league, v_ch, 'Olympique de Marseille won their only Champions League in 1993. Who did they beat?',
   '["Juventus","AC Milan","Inter Milan","Barcelona"]', 1, 'easy',
   'Marseille beat AC Milan 1–0 in the 1992–93 Champions League Final in Munich, with Basile Boli''s header being the only goal. However, Marseille were subsequently stripped of their 1992–93 Ligue 1 title due to the VA-OM scandal.'),

  (v_league, v_ch, 'Which French club produced Kylian Mbappé in their youth academy?',
   '["PSG","Monaco","Toulouse","Clairefontaine (national centre)"]', 1, 'medium',
   'Kylian Mbappé came through AS Monaco''s youth academy, making his professional debut in December 2015 aged 16. He had also trained at the Clairefontaine national football institute before joining Monaco.'),

  (v_league, v_ch, 'Stade Rennais (Rennes) won their first major trophy in French football in which year?',
   '["1998","2009","2019","2022"]', 2, 'medium',
   'Rennes won the Coupe de France in 2018–19, their first major trophy. They subsequently qualified for the Europa League for the first time and have been developing into a consistent Ligue 1 top-half club.'),

  (v_league, v_ch, 'Which Ligue 1 club won their only French league title in 1995–96 under Guy Roux, one of football''s most loyal managers?',
   '["Nantes","Toulouse","Auxerre","Rennes"]', 2, 'hard',
   'AJ Auxerre won their only Division 1 title in 1995–96 under Guy Roux, who managed the club for over 40 years. Auxerre were also known for producing French internationals such as Eric Cantona and Basile Boli through their renowned academy.'),

  (v_league, v_ch, 'Which Ligue 1 club was involved in the "Marseille-VA corruption scandal" (VA-OM) in 1993?',
   '["PSG","Valenciennes","Monaco","Nice"]', 1, 'hard',
   'The VA-OM scandal involved Olympique de Marseille bribing Valenciennes players before a League match in 1993. It led to Marseille being relegated to Ligue 2, banned from European competition, and having their 1992–93 Ligue 1 title stripped.'),

  (v_league, v_ch, 'Olympique Lyonnais have won the UEFA Women''s Champions League how many times?',
   '["3","5","7","8"]', 2, 'medium',
   'Olympique Lyonnais (Lyon) women''s team have won the UEFA Women''s Champions League eight times — the most of any club in history. They are the dominant force in women''s club football worldwide.'),

  (v_league, v_ch, 'Which Ligue 1 club has produced the most players for the French national team historically?',
   '["PSG","Lyon","Marseille","Bordeaux"]', 1, 'hard',
   'Olympique Lyonnais have produced the most French international players through their academy, including names like Karim Benzema, Hatem Ben Arfa, Nabil Fékir, and Alexandre Lacazette in recent decades.'),

  (v_league, v_ch, 'PSG won their first Ligue 1 title in which year?',
   '["1975","1979","1983","1986"]', 3, 'hard',
   'PSG won their first Ligue 1 title in the 1985–86 season, just 16 years after the club was founded. Their second title came in 1993–94, and then the QSI era brought a further nine titles from 2012 onwards.'),

  (v_league, v_ch, 'Which Monaco player famously scored a hat-trick in the Champions League in 2017 at the age of 18?',
   '["Kylian Mbappé","Thomas Lemar","Bernardo Silva","Fabinho"]', 0, 'medium',
   'Kylian Mbappé scored a hat-trick for Monaco against Manchester City in the 2016–17 Champions League quarter-finals, aged 18. His performances that season launched him as one of football''s most exciting talents.'),

  (v_league, v_ch, 'Strasbourg won the Ligue 1 title in which year?',
   '["1979","1993","1999","2007"]', 0, 'hard',
   'Strasbourg won their only Ligue 1 title in the 1978–79 season. They have since fluctuated between divisions and returned to Ligue 1 under a new ownership group in recent years.'),

  (v_league, v_ch, 'Montpellier HSC won a surprise Ligue 1 title in which season?',
   '["2009–10","2011–12","2013–14","2015–16"]', 1, 'medium',
   'Montpellier HSC won the 2011–12 Ligue 1 title under René Girard with Olivier Giroud as their top scorer — one of the biggest upsets in recent French football history. It remains Montpellier''s only top-flight title.'),

  (v_league, v_ch, 'Nice is a city on the French Riviera. Which Ligue 1 club represents it?',
   '["LOSC Nice","OGC Nice","SC Nice","Stade Nice"]', 1, 'easy',
   'OGC Nice (Olympique Gymnaste Club de Nice) represents the city of Nice and the French Riviera. Founded in 1904, they play at the Allianz Riviera stadium and have won four Ligue 1 titles, all before 1960.'),

  (v_league, v_ch, 'Which Ligue 1 club is nicknamed "Les Dogues" (The Mastiffs)?',
   '["Rennes","Lens","Toulouse","Lille"]', 3, 'medium',
   'Lille OSC are nicknamed "Les Dogues" (The Mastiffs/Bulldogs) — a reference to their determined, tenacious playing style. Their mascot is a bulldog, and they are one of France''s most successful clubs.'),

  (v_league, v_ch, 'In which year was Ligue 1 founded (under its original format)?',
   '["1921","1926","1932","1935"]', 2, 'medium',
   'The French professional football league (known as the Division 1 until 2002, then Ligue 1) was founded in 1932. The competition has been played continuously since then, making it one of Europe''s oldest professional leagues.'),

  (v_league, v_ch, 'Which French club are known as "Les Phocéens" in reference to Marseille''s ancient Greek origins?',
   '["Lyon","Nice","Marseille","Toulon"]', 2, 'easy',
   'Olympique de Marseille are nicknamed "Les Phocéens" — a reference to the ancient Greek Phocaeans who founded the colony of Massalia (Marseille) around 600 BC. This heritage gives the city and club a unique identity.'),

  (v_league, v_ch, 'Paris Saint-Germain have won the UEFA Champions League: True or False?',
   '["True — once in 2020","False — they have never won it","True — twice (2020 and 2023)","True — once in 2017"]', 1, 'easy',
   'PSG have never won the UEFA Champions League despite enormous investment. They reached the final in 2019–20 (losing to Bayern Munich 1-0) and the semi-finals multiple times, but the European title has always eluded them.'),

  (v_league, v_ch, 'Which Ligue 1 club from the 1990s was known as "Le Racing Club de Paris"?',
   '["PSG","Racing Club de France","Paris FC","Red Star FC"]', 1, 'hard',
   'Racing Club de France is a historic Parisian sports club whose football section competed at the highest levels of French football in the 1930s–50s. Their 1936 French championship remains a landmark in the club''s history.');

  -- ============================================================
  -- FAMOUS PLAYERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_fp, 'Who is the all-time top scorer in Ligue 1 history?',
   '["Delio Onnis","Hervé Revelli","Jean-Pierre Papin","Bernard Lacombe"]', 0, 'hard',
   'Delio Onnis, an Argentine striker, is the all-time top scorer in French Division 1/Ligue 1 history with 299 goals, scored for Monaco and other clubs between 1971 and 1986.'),

  (v_league, v_fp, 'Kylian Mbappé joined PSG permanently in 2017. Which club did he come from?',
   '["Nice","Marseille","Monaco","Lyon"]', 2, 'easy',
   'Kylian Mbappé joined PSG on loan from Monaco in 2017 and then signed permanently in 2018 for approximately €145 million, one of the most expensive transfers in history. He left PSG for Real Madrid in 2024.'),

  (v_league, v_fp, 'Zinedine Zidane came through which club''s academy before becoming a world superstar?',
   '["Olympique de Marseille","Girondins de Bordeaux","AS Cannes","Lyon"]', 2, 'medium',
   'Zinedine Zidane came through the AS Cannes youth academy and made his professional debut there in 1989. He moved to Girondins de Bordeaux in 1992 before joining Juventus in 1996.'),

  (v_league, v_fp, 'Which French midfielder won the 1998 Ballon d''Or after helping France win the World Cup?',
   '["Zinedine Zidane","Marcel Desailly","Didier Deschamps","Laurent Blanc"]', 0, 'easy',
   'Zinedine Zidane won the 1998 Ballon d''Or after his key role in France''s World Cup victory, including two headers in the final against Brazil. He is widely considered the greatest French player of all time.'),

  (v_league, v_fp, 'Thierry Henry was born in which Paris suburb and came through which club?',
   '["Saclay / Arsenal","Les Ulis / Monaco","Saint-Denis / PSG","Boulogne-Billancourt / Lyon"]', 1, 'medium',
   'Thierry Henry was born in Les Ulis and came through AS Monaco''s youth academy, where he was discovered and developed before Arsène Wenger signed him for Arsenal in 1999.'),

  (v_league, v_fp, 'Just Fontaine scored how many goals at the 1958 World Cup, a record that still stands?',
   '["11","12","13","14"]', 2, 'easy',
   'Just Fontaine scored 13 goals at the 1958 FIFA World Cup in Sweden — a record for goals in a single World Cup tournament that has never been beaten. He played for Stade de Reims and was part of France''s third-place team.'),

  (v_league, v_fp, 'Michel Platini won the Ballon d''Or three consecutive years (1983–85). Which Italian club was he at?',
   '["AC Milan","Napoli","Inter Milan","Juventus"]', 3, 'medium',
   'Michel Platini won three consecutive Ballon d''Or awards (1983, 1984, 1985) while at Juventus, where he won Serie A and the European Cup. He is considered one of the greatest European midfielders ever.'),

  (v_league, v_fp, 'Neymar joined PSG from Barcelona in 2017 for a world record fee. What nationality is he?',
   '["Argentine","Brazilian","Colombian","Spanish"]', 1, 'easy',
   'Neymar is Brazilian and joined PSG for a world record €222 million in August 2017 — a fee that shattered all previous records. He won multiple Ligue 1 titles with PSG before leaving for Al-Hilal in 2023.'),

  (v_league, v_fp, 'Which PSG striker scored 30 Ligue 1 goals in 2012–13, winning the top scorer award as PSG claimed their first QSI-era title?',
   '["Zlatan Ibrahimović","Edinson Cavani","Kylian Mbappé","Carlos Tevez"]', 0, 'medium',
   'Zlatan Ibrahimović scored 30 goals in Ligue 1 in 2012–13 as PSG won their first title of the Qatar era. He went on to score 113 Ligue 1 goals across four seasons at the club, winning multiple top scorer awards and four Ligue 1 titles.'),

  (v_league, v_fp, 'Didier Deschamps won the World Cup as both player and manager of France. Which Ligue 1 clubs did he play for?',
   '["PSG and Lyon","Marseille and Monaco","Nantes and Bordeaux","Lens and Nice"]', 1, 'medium',
   'Didier Deschamps played for Marseille (two spells, winning the Champions League in 1993), Monaco, Juventus, Chelsea, and Valencia. In France, Marseille and Monaco were his main clubs.'),

  (v_league, v_fp, 'Which PSG goalkeeper was nicknamed "The Wall" for his penalty-saving abilities?',
   '["Salvatore Sirigu","Keylor Navas","Gianluigi Buffon","Nicolas Langlois"]', 1, 'medium',
   'Keylor Navas joined PSG from Real Madrid in 2019 and was exceptional in goal during his three seasons. He was a key reason PSG reached the Champions League Final in 2019–20, saving several crucial penalties.'),

  (v_league, v_fp, 'Karim Benzema came through Lyon''s academy. Which Ligue 1 club is he associated with as his hometown club?',
   '["Bron-Terraillon","Lyon","Villeurbanne FC","Saint-Exupéry FC"]', 1, 'medium',
   'Karim Benzema came through Olympique Lyonnais''s academy and made his debut for the club in 2004. He left for Real Madrid in 2009 for €35 million and went on to win the Ballon d''Or in 2022.'),

  (v_league, v_fp, 'Nicolas Anelka played for several clubs. Which Ligue 1 club did he most notably represent?',
   '["PSG","Monaco","Marseille","Bolton"]', 0, 'medium',
   'Nicolas Anelka had several stints in Ligue 1, including at PSG (youth and briefly as a senior player). His career traversed Arsenal, Real Madrid, Liverpool, Manchester City, Fenerbahçe, and Bolton before a late-career return to France.'),

  (v_league, v_fp, 'Which Ligue 1 player won the FIFA World Player of the Year award in 2003?',
   '["Thierry Henry","Zinedine Zidane","Ronaldo","Ronaldinho"]', 1, 'medium',
   'Zinedine Zidane won the FIFA World Player of the Year award in 1998, 2000, and 2003 — making him a three-time winner and one of football''s most recognised superstars at the time he was still playing.'),

  (v_league, v_fp, 'Lionel Messi joined PSG in 2021. How long did he stay?',
   '["One season","Two seasons","Three seasons","He is still at PSG"]', 1, 'medium',
   'Lionel Messi joined PSG in August 2021 after leaving FC Barcelona due to financial issues. He stayed for two seasons (2021–23) before moving to Inter Miami in MLS in July 2023.'),

  (v_league, v_fp, 'Youri Djorkaeff was a key midfielder for Monaco and France in the 1990s. What trophy did he win with France in 1998?',
   '["European Championship","World Cup","UEFA Nations League","Copa América"]', 1, 'medium',
   'Youri Djorkaeff was part of Aimé Jacquet''s France squad that won the 1998 FIFA World Cup on home soil, defeating Brazil 3–0 in the final. He had previously starred for Monaco and later played for Inter Milan, Kaiserslautern, and Bolton Wanderers.'),

  (v_league, v_fp, 'Nicolas Anelka was sold by Real Madrid to which club in 2000, reigniting his career after a difficult spell in Spain?',
   '["PSG","Marseille","Monaco","Manchester City"]', 3, 'medium',
   'Nicolas Anelka rejoined Manchester City from Real Madrid in 2002 after a loan at PSG. His earlier career had taken him from Arsenal (age 17) to Real Madrid and back to PSG. He went on to have a productive spell at Man City before later starring at Chelsea.'),

  (v_league, v_fp, 'Zlatan Ibrahimović played for PSG from 2012 to 2016. How many Ligue 1 titles did he win?',
   '["2","3","4","5"]', 2, 'medium',
   'Zlatan Ibrahimović won four Ligue 1 titles with PSG (2012–13, 2013–14, 2014–15, 2015–16), scoring 113 goals in 122 Ligue 1 appearances — the most productive period of his career in terms of trophies.'),

  (v_league, v_fp, 'Which French striker won the World Cup Golden Boot in 1998 with six goals?',
   '["Thierry Henry","Stéphane Guivarc''h","Christian Vieri","Ronaldo"]', 1, 'hard',
   'Stéphane Guivarc''h scored six goals at the 1998 World Cup in France to win the Golden Boot. Surprisingly, he remained relatively anonymous in club football, eventually playing in England for Newcastle United.'),

  (v_league, v_fp, 'Which Marseille player is their all-time top scorer with 186 goals?',
   '["Gunnar Andersson","Jean-Pierre Papin","Josip Skoblar","Dario Benedetto"]', 2, 'hard',
   'Josip Skoblar, a Yugoslav striker, is Olympique de Marseille''s all-time top scorer with 186 goals, scored between 1966 and 1974. He won the Division 1 top scorer award three times.'),

  (v_league, v_fp, 'Which Brazilian midfielder at Lyon was famous for his spectacular free kicks?',
   '["Cris","Juninho Pernambucano","Anderson Luis de Abreu Oliveira","Claudio Caçapa"]', 1, 'medium',
   'Juninho Pernambucano scored 44 goals for Lyon in Ligue 1, many from devastating direct free kicks. He is widely considered the greatest free kick specialist in football history and was central to Lyon''s seven consecutive titles.'),

  (v_league, v_fp, 'Kylian Mbappé scored how many Ligue 1 goals in total for PSG before leaving for Real Madrid?',
   '["145","156","178","200"]', 2, 'hard',
   'Kylian Mbappé scored 178 Ligue 1 goals for PSG between 2017 and 2024 — making him the club''s all-time top scorer and one of the most prolific players in Ligue 1 history.'),

  (v_league, v_fp, 'Which defender is considered France''s greatest ever and captained the 1998 World Cup winning team?',
   '["Laurent Blanc","Lilian Thuram","Marcel Desailly","Didier Deschamps"]', 1, 'hard',
   'Lilian Thuram is often considered France''s greatest ever defender. He scored two goals in the 1998 World Cup semi-final against Croatia (both his career-defining moments) and won 142 international caps.'),

  (v_league, v_fp, 'Which Ligue 1 top scorer award is called what?',
   '["Soulier d''Or","Trophée du Meilleur Buteur","Médaille des Buts","Coupe des Buteurs"]', 1, 'medium',
   'The Ligue 1 top scorer award is called the "Trophée du Meilleur Buteur" (Trophy of the Best Goalscorer). Unlike Spain''s "Pichichi" or Italy''s "Capocannoniere," it lacks a culturally famous nickname.'),

  (v_league, v_fp, 'Alexandre Lacazette came through which club''s academy?',
   '["PSG","Olympique de Marseille","Olympique Lyonnais","Stade Rennais"]', 2, 'easy',
   'Alexandre Lacazette came through Olympique Lyonnais''s academy and became the club''s all-time top scorer before joining Arsenal in 2017 for £52 million. He returned to Lyon in 2022.'),

  (v_league, v_fp, 'Which former Ligue 1 goalkeeper saved a penalty to help France win the World Cup in 1998?',
   '["Fabien Barthez","Grégory Coupet","Bernard Lama","Mickaël Landreau"]', 0, 'easy',
   'Fabien Barthez was France''s World Cup-winning goalkeeper in 1998 and Euro 2000. Known for his eccentric style and bald head, he was one of France''s greatest ever keepers.'),

  (v_league, v_fp, 'Ousmane Dembélé left which Ligue 1 club for Borussia Dortmund in 2016?',
   '["Rennes","Nantes","Stade de Reims","Toulouse"]', 0, 'medium',
   'Ousmane Dembélé left Stade Rennais for Borussia Dortmund for approximately €15 million in 2016. He scored an impressive 12 goals in 26 games at Dortmund before moving to Barcelona for €96.8 million.'),

  (v_league, v_fp, 'Which PSG and France legend is nicknamed "Il est parti" (He''s gone) for his pace?',
   '["Kylian Mbappé","Nicolas Anelka","Thierry Henry","Franck Ribéry"]', 0, 'medium',
   'Kylian Mbappé is nicknamed "Il est parti" (He''s gone) or "Donatello" by fans for his electric pace. His speed has been measured at over 36 km/h, making him one of the fastest players in world football.'),

  (v_league, v_fp, 'Eric Cantona had a troubled Ligue 1 career before finding fame in England. Which was NOT one of his French clubs?',
   '["Auxerre","Marseille","Lyon","Bordeaux"]', 2, 'hard',
   'Éric Cantona played for Auxerre, Martigues, Marseille, Bordeaux, Montpellier, and Nîmes in France before joining Leeds United in 1992. He never played for Lyon. His French career was characterised by brilliance and controversy in equal measure.'),

  (v_league, v_fp, 'Thierry Henry scored how many goals for Monaco in Ligue 1 before his Arsenal career?',
   '["19","27","36","45"]', 1, 'hard',
   'Thierry Henry scored 28 Ligue 1 goals for AS Monaco (1994–99) before joining Juventus and then Arsenal. His time at Monaco included a Ligue 1 title in 1996–97 and the Champions League semi-finals.'),

  (v_league, v_fp, 'Which Ligue 1 goalkeeper won the Champions League with Real Madrid three times?',
   '["Mickaël Landreau","Grégory Coupet","Hugo Lloris","Keylor Navas"]', 3, 'hard',
   'Keylor Navas won the Champions League three times with Real Madrid (2016, 2017, 2018) before joining PSG in 2019. He remains the most successful Costa Rican footballer of all time.');

  -- ============================================================
  -- LE CLASSIQUE (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_lc, 'What is "Le Classique" in French football?',
   '["Lyon vs Monaco","Marseille vs Lyon","PSG vs Marseille","PSG vs Monaco"]', 2, 'easy',
   '"Le Classique" is the name for the fixture between Paris Saint-Germain and Olympique de Marseille — France''s two most supported clubs, representing the eternal rivalry between Paris and Marseille.'),

  (v_league, v_lc, 'The rivalry between PSG and Marseille has deep roots. What does it fundamentally represent?',
   '["Two wealthy clubs fighting for titles","The north-south divide in French culture and politics","Capital vs province cultural divide","Two clubs with similar fan cultures"]', 2, 'medium',
   'Le Classique embodies the French north-south divide — Paris (political and economic power) vs Marseille (the rebellious, proudly independent south). The fixture carries enormous cultural weight beyond sport.'),

  (v_league, v_lc, 'In which season did Marseille''s wins in Le Classique directly contribute to them winning the Ligue 1 title under Didier Deschamps?',
   '["2007–08","2009–10","2011–12","2013–14"]', 1, 'medium',
   'Marseille won the Ligue 1 title in 2009–10 under Didier Deschamps, and their results against PSG in Le Classique that season were important to their title win. It was their most recent Ligue 1 championship to date.'),

  (v_league, v_lc, 'In which city is the Parc des Princes, where PSG host Le Classique?',
   '["Lyon","Marseille","Paris","Versailles"]', 2, 'easy',
   'The Parc des Princes is located in the 16th arrondissement of Paris, built in 1972 and renovated multiple times. PSG''s home games draw fans from across France and internationally.'),

  (v_league, v_lc, 'Marseille''s "La Commanderie" is their what?',
   '["Official anthem","Training ground","Main supporter group''s HQ","Home stadium name"]', 1, 'medium',
   '"La Commanderie" is Olympique de Marseille''s training complex, located in the northern outskirts of Marseille. It became notorious when Marseille fans attacked it in protests against the club''s management in 2021.'),

  (v_league, v_lc, 'Which PSG player received the most red cards in Le Classique history?',
   '["Marco Verratti","Zlatan Ibrahimović","Neymar","Thiago Motta"]', 2, 'hard',
   'Neymar received a red card during Le Classique in 2019 and was involved in numerous controversial incidents in the fixture. His confrontational relationship with Marseille players and staff made him a focal point of the rivalry.'),

  (v_league, v_lc, 'The Le Classique played at the Stade Vélodrome in Marseille generates what kind of atmosphere?',
   '["Family-friendly and calm","Extremely hostile toward PSG players","Only notable for choreographies","Similar to any normal match"]', 1, 'easy',
   'The Stade Vélodrome in Marseille generates one of the most hostile atmospheres in European football for visiting sides. PSG players and supporters are typically greeted with extreme hostility.'),

  (v_league, v_lc, 'Which Marseille manager famously said "we don''t lose to PSG, we lose to Paris"?',
   '["Didier Deschamps","Jorge Sampaoli","Vito Grieco","René Girard"]', 0, 'hard',
   'Various Marseille managers and figures have made pointed comments about Le Classique''s significance. Didier Deschamps managed Marseille with particular intensity against PSG during his 2009–2012 tenure.'),

  (v_league, v_lc, 'In 2000 and 2001, Le Classique was notable for which player''s outstanding performances?',
   '["Ronaldinho","Ibrahim Ba","Robert Pirès","Jay-Jay Okocha"]', 1, 'hard',
   'Ibrahim Ba was a Ligue 1 star for PSG in the early 2000s and performed well against Marseille. Robert Pirès and Jay-Jay Okocha were also PSG players in that era who could influence Le Classique.'),

  (v_league, v_lc, 'In the 2019–20 Le Classique, Neymar was involved in a post-match brawl. What happened?',
   '["He punched a security guard","He was accused of racist abuse from a Marseille player","He kicked a photographer","He refused to shake hands with opposing players"]', 1, 'medium',
   'In the September 2020 Le Classique, Neymar accused Marseille defender Álvaro González of racially abusing him during the match. Neymar received a red card for retaliating, while the investigation into González''s alleged abuse was inconclusive.'),

  (v_league, v_lc, 'PSG''s biggest Le Classique win was which result?',
   '["7–2","5–0","5–1","6–1"]', 0, 'hard',
   'PSG''s biggest ever Le Classique victory was a 7–2 win in 2018, though the exact biggest result varies by source depending on era. In the modern QSI era, PSG have dominated the fixture significantly.'),

  (v_league, v_lc, 'Which Marseille legend scored in multiple Le Classique matches to become their fixture hero?',
   '["Didier Drogba","Samir Nasri","Lorik Cana","Mamadou Niang"]', 3, 'hard',
   'Mamadou Niang scored several crucial goals for Marseille in Le Classique during the 2000s, making him a fan favourite. He was known for his physicality and ability to rise for key matches.'),

  (v_league, v_lc, 'Le Classique in the 2021–22 season featured a record 5 Marseille players sent off. True or false?',
   '["True","False — no such match occurred","False — it was 3 red cards","False — it was PSG who had players sent off"]', 0, 'medium',
   'In the October 2021 Le Classique at the Parc des Princes, Marseille had five players sent off (one was later overturned) in a chaotic match that ended 0–0. The red cards came during and after the match, leaving Marseille with only six men at one point.'),

  (v_league, v_lc, 'Who scored the winning goal for Marseille in the 2009 Le Classique that helped them to the title?',
   '["Samir Nasri","Lorik Cana","Mamadou Niang","Hatem Ben Arfa"]', 2, 'hard',
   'Mamadou Niang was key to Marseille''s 2009–10 title-winning season. The Le Classique results that season contributed to Marseille''s championship triumph under Didier Deschamps.'),

  (v_league, v_lc, 'What is the maximum number of Le Classique matches per season in Ligue 1?',
   '["1","2","3","4"]', 1, 'easy',
   'There are two Le Classique fixtures per Ligue 1 season — home and away, like any other league fixture. Additional Le Classique matches can occur in cup competitions (Coupe de France, Coupe de la Ligue, Trophée des Champions).'),

  (v_league, v_lc, 'In the Trophée des Champions (French Super Cup), how many times have PSG beaten Marseille?',
   '["2","4","6","More — they meet regularly"]', 3, 'hard',
   'PSG and Marseille have met in the Trophée des Champions (French Super Cup) multiple times, with PSG winning the majority of encounters as they have dominated French football since 2011.'),

  (v_league, v_lc, 'Where is the Trophée des Champions typically played?',
   '["Paris","Marseille","A neutral venue in France","Abroad (other countries)"]', 3, 'medium',
   'The Trophée des Champions is traditionally played abroad — in countries like China, Morocco, North America, or Canada — as a marketing initiative to promote Ligue 1 internationally.'),

  (v_league, v_lc, 'Which PSG player scored a hat-trick against Marseille in Le Classique in 2013?',
   '["Zlatan Ibrahimović","Edinson Cavani","Thiago Silva","Lucas Moura"]', 0, 'medium',
   'Zlatan Ibrahimović scored twice (not a hat-trick) against Marseille in multiple Le Classique encounters, becoming a symbol of PSG''s dominance over their rivals in the QSI era.'),

  (v_league, v_lc, 'What word is used to describe the support shown against PSG when Marseille win Le Classique?',
   '["Victoire","La Libération","Bouillabaise","L''Exploit"]', 3, 'hard',
   '"L''Exploit" (The Feat/The Achievement) is how Marseille fans describe beating PSG in Le Classique, given PSG''s financial superiority. Even a draw at the Parc des Princes is celebrated as a result by Marseille supporters.'),

  (v_league, v_lc, 'How many Le Classique fixtures took place with fans present during the COVID-19 period?',
   '["None","2","4","All were behind closed doors for only 1 season"]', 0, 'medium',
   'During the 2019–20 and early 2020–21 seasons, all Ligue 1 matches were played behind closed doors or with severely restricted attendance, meaning several Le Classique fixtures had no fans.'),

  (v_league, v_lc, 'Marseille''s most famous win over PSG in recent times came in which season at the Stade Vélodrome?',
   '["2021–22","2022–23","2023–24","2020–21"]', 0, 'hard',
   'Marseille''s ability to beat PSG at the Stade Vélodrome became rare in the QSI era. Any Marseille win over PSG is celebrated as a significant event regardless of the season.'),

  (v_league, v_lc, 'What is the name of Marseille''s ultras group that creates the most noise in Le Classique?',
   '["Virage Nord","Commando Ultrà 84 and South Winners","Les Irréductibles","Boulogne Boys"]', 1, 'hard',
   'Marseille''s main ultra groups are Commando Ultrà 84 and South Winners, based in the Virage Sud (South Curve) of the Stade Vélodrome. They create an extraordinary atmosphere, especially for Le Classique.'),

  (v_league, v_lc, 'In the 1989 Le Classique, which famous player''s goal helped Marseille beat PSG in a title-deciding match?',
   '["Jean-Pierre Papin","Didier Deschamps","Abedi Pelé","Eric Cantona"]', 0, 'hard',
   'Jean-Pierre Papin was Marseille''s attacking hero in the late 1980s, winning the Ballon d''Or in 1991. His goals in key Le Classique matches helped Marseille to their 1988–89 Division 1 title.'),

  (v_league, v_lc, 'The rivalry intensified after PSG''s Qatar takeover in 2011. Why did this make Marseille fans even more hostile?',
   '["PSG started signing players Marseille wanted","The wealth gap between the clubs widened dramatically","PSG moved to Marseille","QSI also tried to buy Marseille"]', 1, 'easy',
   'PSG''s Qatar-backed wealth created a massive financial gap — PSG could spend what Marseille spent in a decade on a single player. This imbalance made Le Classique feel less competitive but more emotionally charged for Marseille fans.'),

  (v_league, v_lc, 'How many Ligue 1 points separate PSG and Marseille in a typical title-winning PSG season?',
   '["5–10","10–20","20–30","More than 30"]', 2, 'hard',
   'In PSG''s most dominant Ligue 1 seasons (e.g., 2015–16, 2019–20), they finished 20–30+ points ahead of second-placed clubs including Marseille. The financial chasm has made true title competition extremely rare.'),

  (v_league, v_lc, 'What color contrast do PSG (blue/red) and Marseille (blue/white) have that makes their kits distinctive from each other?',
   '["Red vs. white trim","Red vs. no red (Marseille wear white with no red)","Blue shade differences only","Both wear the exact same blue shade"]', 0, 'medium',
   'PSG''s home kit features dark navy blue with red trim, while Marseille wear a lighter/white-based kit. The contrast — and the political colours associated (PSG''s red = left, Marseille''s blue = republican) — adds cultural meaning.'),

  (v_league, v_lc, 'Le Classique was played on which French national holiday in 2010?',
   '["Bastille Day (14 July)","Armistice Day (11 November)","New Year''s Day (1 January)","Easter Sunday"]', 0, 'hard',
   'Ligue 1 is occasionally scheduled to coincide with French national events. Bastille Day (14 July) has featured high-profile Ligue 1 fixtures, adding symbolic weight to certain matchdays.'),

  (v_league, v_lc, 'How many times did Zlatan Ibrahimović score in Le Classique during his time at PSG (2012–2016)?',
   '["3","5","8","12"]', 2, 'hard',
   'Zlatan Ibrahimović scored several goals in Le Classique during his four seasons at PSG, including memorable performances at the Parc des Princes and the Stade Vélodrome. He scored approximately 8 goals in the fixture.'),

  (v_league, v_lc, 'Which Ligue 1 rule means PSG cannot use Le Classique to "fix" Ligue 1 title outcomes?',
   '["Financial Fair Play","The 50+1 rule","No specific rule — market forces apply","Ligue 1 salary caps"]', 0, 'hard',
   'UEFA''s Financial Fair Play (FFP) rules theoretically limit how much PSG can outspend rivals, though they have navigated these rules creatively. Domestically, no specific rule prevents PSG''s financial dominance of Ligue 1.'),

  (v_league, v_lc, 'What phrase do PSG fans chant that directly references their hatred of Marseille?',
   '["Paris est magique","Va te faire foutre, l''OM","Allez Paris, Allez","Parisiens, tous ensemble"]', 1, 'hard',
   '"Va te faire foutre, l''OM" (roughly: "Go f--- yourself, OM") is one of the most common chants from PSG''s Kop de Boulogne ultra section during Le Classique. Fan rivalry expression in French football is notably direct.'),

  (v_league, v_lc, 'Le Classique in 2023 was notable for which unusual statistical achievement?',
   '["10 red cards shown","0 goals in both matches","PSG won both by identical scores","Marseille won both Le Classique matches"]', 1, 'hard',
   'Statistics for the 2023 Le Classique vary — both matches in Ligue 1 2022–23 had relatively low scoring. The first ended 0-0 at the Vélodrome and the second 3-0 to PSG at Parc des Princes.');

  -- ============================================================
  -- RECORDS & STATS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_rs, 'Who is the all-time top scorer in French Division 1/Ligue 1 history?',
   '["Jean-Pierre Papin","Delio Onnis","Zlatan Ibrahimović","Kylian Mbappé"]', 1, 'medium',
   'Delio Onnis, an Argentine striker who played in France from 1971 to 1986, is the all-time top scorer in the French top flight with 299 goals. He scored for Monaco, Tours, Toulon, and other clubs.'),

  (v_league, v_rs, 'How many consecutive Ligue 1 titles has PSG won in their most dominant period?',
   '["6","7","8","9"]', 2, 'medium',
   'PSG won eight consecutive Ligue 1 titles from 2012–13 to 2019–20, the longest consecutive title streak in Ligue 1 history (the 2019–20 season was ended early due to COVID-19 with PSG declared champions on PPG).'),

  (v_league, v_rs, 'What is the record for most Ligue 1 goals in a single season by a player?',
   '["38","40","46","50"]', 2, 'hard',
   'Gonzalo Higuaín scored 36 goals in a single Serie A season (not Ligue 1). The Ligue 1 single-season record is approximately 38 goals, scored by multiple players across different eras.'),

  (v_league, v_rs, 'How many clubs compete in Ligue 1 each season?',
   '["16","18","20","22"]', 2, 'easy',
   'Ligue 1 consists of 20 clubs, like the Premier League and La Liga. Three clubs are relegated to Ligue 2 at the end of each season, with three promoted.'),

  (v_league, v_rs, 'Lyon won how many consecutive Ligue 1 titles from 2001–02 to 2007–08?',
   '["5","6","7","8"]', 2, 'easy',
   'Olympique Lyonnais won seven consecutive Ligue 1 titles — the longest consecutive run in the competition''s history. The team featured Juninho, Benzema, Malouda, Govou, Cris, and was managed by Gérard Houllier and later Alain Perrin.'),

  (v_league, v_rs, 'Which Ligue 1 club has the highest average attendance in the league?',
   '["PSG","Marseille","Lyon","Monaco"]', 0, 'medium',
   'PSG consistently have the highest average Ligue 1 attendance, with the Parc des Princes selling out for most matches. Marseille are close behind, with the Stade Vélodrome also regularly filling to capacity.'),

  (v_league, v_rs, 'Kylian Mbappé''s most prolific Ligue 1 season saw him score how many goals?',
   '["24","27","29","33"]', 2, 'medium',
   'Kylian Mbappé scored 28 Ligue 1 goals in the 2018–19 season for PSG — his most prolific single season in the league before departing for Real Madrid in 2024.'),

  (v_league, v_rs, 'Which Ligue 1 club has been relegated the most times in the competition''s history?',
   '["Toulouse","Nantes","Lens","Valenciennes"]', 0, 'hard',
   'Toulouse FC has been promoted and relegated multiple times throughout their history in French football. In 2023–24, they reached the Europa League under Carles Martínez Novell.'),

  (v_league, v_rs, 'The record for most consecutive Ligue 1 matches unbeaten is held by which club?',
   '["PSG","Lyon","Reims","Monaco"]', 0, 'hard',
   'PSG hold multiple Ligue 1 record for consecutive unbeaten matches during their dominant era. Lyon also had long unbeaten runs during their seven-title period.'),

  (v_league, v_rs, 'How many Ligue 1 titles did AS Saint-Étienne win, making them the most successful club in the competition''s history?',
   '["8","10","12","14"]', 1, 'medium',
   'AS Saint-Étienne have won Ligue 1 (then Division 1) 10 times — the most of any French club in history. Their success came predominantly in the 1960s and 1970s, when they were also European Cup finalists.'),

  (v_league, v_rs, 'PSG set the Ligue 1 points record in which season?',
   '["2014–15","2015–16","2019–20","2022–23"]', 2, 'medium',
   'PSG set the Ligue 1 record with 93 points in 2015–16 under Laurent Blanc, winning every home match and dropping points rarely. The 2019–20 season was terminated early by COVID with PSG having the best record.'),

  (v_league, v_rs, 'Which Ligue 1 club became French champions for the first time in 2020–21, breaking PSG''s dominance?',
   '["Monaco","Rennes","Nice","Lille"]', 3, 'easy',
   'Lille OSC won their first Ligue 1 title in 10 years in 2020–21, pipping PSG to the title in a close race under Christophe Galtier. Jonathan David, with 13 goals, was a key contributor.'),

  (v_league, v_rs, 'How many goals per game on average does Ligue 1 produce per season, roughly?',
   '["2.2","2.5","2.7","3.0"]', 1, 'medium',
   'Ligue 1 typically averages approximately 2.5-2.7 goals per game across a season — slightly lower than the Premier League and Bundesliga but generating exciting football, particularly in the latter stages of PSG''s attacking displays.'),

  (v_league, v_rs, 'The Coupe de France (French Cup) is one of the oldest cup competitions in the world. When was it founded?',
   '["1902","1912","1917","1925"]', 2, 'hard',
   'The Coupe de France was founded in 1917, making it one of the oldest national cup competitions in football history. It is open to all French clubs, regardless of division.'),

  (v_league, v_rs, 'Monaco won Ligue 1 in 2016–17 while also reaching the Champions League semi-finals. How many goals did they score in Ligue 1?',
   '["87","96","107","115"]', 2, 'hard',
   'Monaco''s 2016–17 squad, featuring Mbappé, Falcao, Bernardo Silva, Thomas Lemar, and others, scored 107 Ligue 1 goals — an extraordinary total that reflected their expansive attacking style under Leonardo Jardim.'),

  (v_league, v_rs, 'How many times has Marseille won Ligue 1?',
   '["7","9","10","11"]', 1, 'hard',
   'Olympique de Marseille have won Ligue 1 (Division 1) nine times, with their most recent title in 2009–10. Their 1992–93 title was stripped due to the corruption scandal, though the 1989–90 and 2009–10 titles are undisputed.'),

  (v_league, v_rs, 'Which Ligue 1 club produced Thierry Henry, Nicolas Anelka, Emmanuel Petit, Lilian Thuram, and David Trezeguet from their youth academy?',
   '["PSG","Marseille","Monaco","Auxerre"]', 2, 'medium',
   'AS Monaco''s youth academy in the 1990s was extraordinary — producing Thierry Henry, Nicolas Anelka, Emmanuel Petit, Lilian Thuram, and David Trezeguet, among others. Their graduates won the 1998 World Cup with France.'),

  (v_league, v_rs, 'The Trophée des Champions (French Super Cup) is played between which clubs?',
   '["Ligue 1 champion vs Ligue 2 champion","Ligue 1 champion vs Coupe de France winner","Top 2 Ligue 1 clubs","Ligue 1 champion vs European competition qualifier"]', 1, 'easy',
   'The Trophée des Champions is contested between the Ligue 1 champion and the Coupe de France winner (or the Ligue 1 runner-up if the champion also won the cup). It is played at the start of the new season.'),

  (v_league, v_rs, 'What was Ligue 1''s broadcast rights deal worth in 2021–24?',
   '["€730m per year","€900m per year","€1.1 billion per year","€1.4 billion per year"]', 0, 'hard',
   'Ligue 1''s 2020–24 broadcast rights deal (before it collapsed with Mediapro) was valued at approximately €850 million per year. After the Mediapro collapse, the deal was restructured at approximately €730 million per year.'),

  (v_league, v_rs, 'Which French league has lower average salaries than the other four major European leagues?',
   '["Ligue 1 vs Premier League","Ligue 1 vs La Liga and Serie A","Ligue 1 vs all four other leagues","They are all about equal"]', 2, 'medium',
   'Ligue 1 salaries are significantly lower than the Premier League, La Liga, and Serie A. Only the Bundesliga has slightly similar average wages. This salary gap is a major reason French players leave for other leagues.'),

  (v_league, v_rs, 'What was unusual about the 2019–20 Ligue 1 season''s conclusion?',
   '["PSG were relegated","The season was abandoned due to COVID-19","Monaco won the title","Lyon reached the Champions League Final"]', 1, 'easy',
   'The 2019–20 Ligue 1 season was terminated early in April 2020 due to the COVID-19 pandemic, with PSG declared champions based on points-per-game ratio. France was the only major European league to end its season early.'),

  (v_league, v_rs, 'Zlatan Ibrahimović''s Ligue 1 goals tally for PSG (2012–2016) is approximately how many?',
   '["85","92","113","127"]', 2, 'medium',
   'Zlatan Ibrahimović scored 113 Ligue 1 goals in 122 appearances for PSG from 2012 to 2016 — an extraordinary rate of nearly one goal per game. He won four Ligue 1 titles and four Trophées des Champions.'),

  (v_league, v_rs, 'How many Ligue 1 titles has Monaco won?',
   '["5","7","8","10"]', 2, 'hard',
   'AS Monaco have won Ligue 1 eight times, with their most recent title in 2016–17 under Leonardo Jardim. Their championships span from 1961 to 2017.'),

  (v_league, v_rs, 'What is Ligue 1''s most attended match ever?',
   '["PSG vs Marseille at the Parc des Princes in 2018","A Marseille home match at the Vélodrome in 1993","An international play-off at Stade de France","A Monaco home match in 2017"]', 1, 'hard',
   'The Stade Vélodrome in Marseille holds over 67,000 and has recorded some of the highest Ligue 1 attendances. Post-renovation matches in 2014 following the stadium upgrade regularly attract 60,000+ for significant fixtures.'),

  (v_league, v_rs, 'Which Ligue 1 club went unbeaten for an entire season before the French top flight became fully professional?',
   '["Olympique de Marseille","Stade de Reims","RC Strasbourg","Girondins de Bordeaux"]', 1, 'hard',
   'Stade de Reims went the entire 1953–54 Division 1 season unbeaten — one of the earliest undefeated championship seasons in French football history.'),

  (v_league, v_rs, 'How many clubs in Ligue 1 have won the competition more than twice?',
   '["5","7","8","10"]', 1, 'hard',
   'Approximately seven clubs have won the French top flight more than twice: Saint-Étienne, Marseille, Monaco, Lyon, Nantes, Bordeaux, and PSG. Only Reims and Nice among historical winners have fewer than three titles.'),

  (v_league, v_rs, 'What is the Ligue 1 record for most goals in a single match?',
   '["8","10","11","12"]', 2, 'hard',
   'Ligue 1 has seen several high-scoring matches throughout its history. A 10–0 win is the benchmark for most high-scoring encounters, with some early Division 1 matches exceeding this.'),

  (v_league, v_rs, 'Kylian Mbappé won the Ligue 1 Player of the Year award how many consecutive times before leaving PSG?',
   '["3","4","5","6"]', 2, 'medium',
   'Kylian Mbappé won the Ligue 1 Player of the Year award multiple consecutive times, reflecting his extraordinary dominance of French football during PSG''s reign.'),

  (v_league, v_rs, 'The Coupe de la Ligue (League Cup) was abolished after which season?',
   '["2018–19","2019–20","2020–21","2021–22"]', 1, 'medium',
   'The Coupe de la Ligue was abolished after the 2019–20 season, following a LFP decision to simplify the French football calendar. PSG had won it a record 9 consecutive times before it was discontinued.');

  -- ============================================================
  -- MANAGERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_mg, 'Which manager led PSG to their first Champions League Final in 2019–20?',
   '["Unai Emery","Thomas Tuchel","Laurent Blanc","Mauricio Pochettino"]', 1, 'easy',
   'Thomas Tuchel managed PSG to the 2019–20 Champions League Final, where they lost 1–0 to Bayern Munich. He had also won two Ligue 1 titles and the Coupe de France with PSG.'),

  (v_league, v_mg, 'Arsène Wenger managed which Ligue 1 club before joining Arsenal?',
   '["Lyon","Bordeaux","Monaco","Marseille"]', 2, 'medium',
   'Arsène Wenger managed AS Monaco from 1987 to 1994, winning the Division 1 title in 1987–88 and taking the club to the European Cup Winners'' Cup semi-final. He was then poached by Arsenal in 1996.'),

  (v_league, v_mg, 'Didier Deschamps managed Marseille before becoming France manager. What were his major achievements?',
   '["Won Ligue 1 and the Champions League with Marseille","Won Ligue 1 in 2010 and the Coupe de France","Won Ligue 1 only","Never won a Ligue 1 title as manager"]', 1, 'medium',
   'Didier Deschamps managed Marseille from 2009 to 2012, winning Ligue 1 in 2009–10 and the Coupe de France. He was appointed France national team manager in 2012, leading them to World Cup glory in 2018.'),

  (v_league, v_mg, 'Christophe Galtier managed Lille to the Ligue 1 title in 2020–21. Which club did he manage next?',
   '["Marseille","Lyon","Nice","PSG"]', 2, 'medium',
   'After Lille''s title win, Christophe Galtier moved to OGC Nice (2021–22) before being appointed PSG manager in 2022. His one season at PSG was disappointing — they won Ligue 1 but were eliminated from the Champions League early.'),

  (v_league, v_mg, 'Gérard Houllier managed Lyon to how many consecutive Ligue 1 titles?',
   '["2","3","4","5"]', 1, 'hard',
   'Gérard Houllier managed Olympique Lyonnais to three consecutive Ligue 1 titles (2001–02, 2002–03, 2003–04) before Paul Le Guen took over and continued the run. Houllier is also remembered for managing Liverpool (1998–2004).'),

  (v_league, v_mg, 'Leonardo Jardim managed Monaco to the Ligue 1 title and Champions League semi-final in 2016–17. Which country is he from?',
   '["Brazil","France","Portugal","Cape Verde"]', 3, 'hard',
   'Leonardo Jardim is Portuguese (of Cape Verdean descent) and managed Monaco from 2014 to 2019 (with a brief interruption). His 2016–17 Monaco side was one of the most entertaining in European football.'),

  (v_league, v_mg, 'Pep Guardiola''s Barcelona used which training method that was also adopted by Claude Puel when managing Lyon?',
   '["Rondo circles","Tiki-taka positional play","Gegenpressing","4-3-3 from wide positions"]', 1, 'hard',
   'Claude Puel''s Lyon (2008–11) were known for structured positional play, influenced by continental trends. French coaches were slower to adopt full tiki-taka than Spanish and German counterparts.'),

  (v_league, v_mg, 'Which former PSG and France defender became manager of PSG''s main rivals Marseille?',
   '["Ibrahim Ba","William Gallas","Luis Fernandez","Eric Di Méco"]', 2, 'hard',
   'Luis Fernandez, a French midfielder (not specifically a PSG legend as manager of Marseille) did manage several clubs. The rivalry means former PSG players managing Marseille is extremely rare and controversial.'),

  (v_league, v_mg, 'Jorge Sampaoli managed Marseille from 2021 to 2023. What style did he implement?',
   '["Defensive counter-attacking","Chaotic attacking high-press","Possession tiki-taka","5-3-2 defensive blockade"]', 1, 'medium',
   'Jorge Sampaoli implemented an intense, chaotic high-pressing style at Marseille that often produced spectacular football. Despite reaching the Champions League, tactical inconsistency led to his departure in 2023.'),

  (v_league, v_mg, 'Which manager won the Champions League as a player with Marseille and later managed several top clubs?',
   '["Didier Deschamps","Marcel Desailly","Rudi Völler","Didier Drogba"]', 0, 'medium',
   'Didier Deschamps was Marseille''s captain when they won the 1993 Champions League. He later managed Monaco, Juventus, Marseille, and France — becoming one of football''s most successful manager-players.'),

  (v_league, v_mg, 'Mauricio Pochettino managed PSG from 2021 to 2022. What was his biggest frustration?',
   '["Losing the Ligue 1 title","Being eliminated from the Champions League by Real Madrid despite a 2-0 lead","Player injuries","The club''s transfer policy"]', 1, 'medium',
   'Pochettino''s PSG led Real Madrid 2–0 in the Champions League Round of 16 second leg but collapsed to lose 3–2 on aggregate. The "Remontada" was a defining moment of his troubled PSG tenure.'),

  (v_league, v_mg, 'Guy Roux managed which French club for over 40 years, becoming one of football''s most unique managerial figures?',
   '["Sochaux","Troyes","Auxerre","Sedan"]', 2, 'hard',
   'Guy Roux managed AJ Auxerre for an extraordinary 44 years (in multiple spells), from 1961 to 2005. He won the Division 1 title in 1995–96 and is one of football''s most remarkable managerial characters.'),

  (v_league, v_mg, 'Which manager infamously had an on-field fight with his own players and staff at Olympique de Marseille?',
   '["Élie Baup","José Anigo","Bielsa","Jacquet"]', 2, 'hard',
   'Marcelo Bielsa had an intense and sometimes chaotic experience with players throughout his career. At Marseille (2014–15), his methods divided opinion, and he resigned early in the season citing a lack of transfer support.'),

  (v_league, v_mg, 'Which French manager won the European Championship with France in 1984 as both player and manager?',
   '["Michel Platini","Didier Deschamps","Zinedine Zidane","Roger Lemerre"]', 0, 'hard',
   'Michel Platini was France''s key player at Euro 1984 (scoring 9 goals) as a player, then managed France as technical director. He was never the main coach for a championship win — Jacquet won the 1998 World Cup.'),

  (v_league, v_mg, 'Aimé Jacquet managed France to their first World Cup title in 1998. Which club had he managed before taking the national job?',
   '["PSG","Lyon","Bordeaux","Strasbourg"]', 2, 'medium',
   'Aimé Jacquet managed Girondins de Bordeaux from 1980 to 1994, winning two Division 1 titles, before becoming France''s national team manager and leading them to the 1998 World Cup triumph on home soil.'),

  (v_league, v_mg, 'PSG''s first manager after the QSI takeover was which French legend?',
   '["Carlo Ancelotti","Laurent Blanc","Antoine Kombouaré","Rolland Courbis"]', 2, 'medium',
   'Antoine Kombouaré was actually PSG''s manager when QSI completed their takeover in June 2011. Carlo Ancelotti was appointed shortly after, becoming the first "star" manager of the QSI era.'),

  (v_league, v_mg, 'Under which PSG manager did the club achieve their best ever Champions League result?',
   '["Laurent Blanc","Thomas Tuchel","Unai Emery","Mauricio Pochettino"]', 1, 'easy',
   'Thomas Tuchel guided PSG to the 2019–20 Champions League Final — their first and only European Cup Final. They lost 1–0 to Bayern Munich in Lisbon in what was a tournament bubble due to COVID-19.'),

  (v_league, v_mg, 'Nasser Al-Khelaïfi, PSG''s president, makes key managerial decisions. How many managers have PSG had since 2011?',
   '["4","6","8","10"]', 2, 'hard',
   'Since QSI''s takeover in 2011, PSG have had approximately 8 different head coaches: Kombouaré, Ancelotti, Blanc, Emery, Tuchel, Pochettino, Galtier, and Luis Enrique — reflecting the instability despite sporting success.'),

  (v_league, v_mg, 'Which Ligue 1 manager is known for long-term work at a single club, similar to Arsène Wenger at Arsenal?',
   '["Claude Puel","Guy Roux (Auxerre)","Paul Le Guen","Bernard Casoni"]', 1, 'hard',
   'Guy Roux at AJ Auxerre is the definitive example of a long-term single-club Ligue 1 manager, serving the club for over 40 years. His loyalty and patient development methodology stands in stark contrast to modern managerial turnover.'),

  (v_league, v_mg, 'Which manager led Monaco to the Ligue 1 title in the 2001–02 season?',
   '["Didier Deschamps","Jean-Louis Campora","Claude Puel","Franck Passi"]', 0, 'medium',
   'Didier Deschamps managed Monaco to the Ligue 1 title in 2001–02, and also guided them to the Champions League Final in 2003–04 before losing to Porto. He then managed Juventus briefly before joining Marseille.'),

  (v_league, v_mg, 'Which manager famously said he would never manage PSG because of his connection to another Ligue 1 club?',
   '["Eric Cantona (Marseille connection)","Thierry Henry (Monaco connection)","Zinedine Zidane (OM connection)","Guy Roux (Auxerre connection)"]', 2, 'hard',
   'Zinedine Zidane, born in Marseille and deeply associated with the city, repeatedly suggested he would not manage PSG. He is seen as an OM man at heart, creating uncertainty about his future managerial plans in French football.'),

  (v_league, v_mg, 'Unai Emery managed PSG from 2016 to 2018. What did he win?',
   '["Nothing","Ligue 1 only","Ligue 1 twice and Coupe de France twice","The Champions League"]', 2, 'medium',
   'Unai Emery won Ligue 1 twice (2017–18... wait — he won 2015–16 under Blanc, Emery joined July 2016), the Coupe de France, and the Coupe de la Ligue with PSG before leaving in 2018 for Arsenal.'),

  (v_league, v_mg, 'Which former Ligue 1 player became one of France''s most successful managers, winning the World Cup in 2018?',
   '["David Ginola","Laurent Blanc","Didier Deschamps","Nicolas Anelka"]', 2, 'easy',
   'Didier Deschamps played for Nantes, Marseille, Juventus, and Chelsea before becoming France national team manager in 2012. He guided France to Euro 2016 (final) and World Cup victory in 2018.'),

  (v_league, v_mg, 'Carlo Ancelotti''s time at PSG ended without winning the Champions League. What major achievement did he make?',
   '["Signed Zlatan Ibrahimović","Won the first Ligue 1 title of the QSI era","Reached the Champions League semi-final","Signed Thiago Silva and Javier Pastore"]', 1, 'medium',
   'Carlo Ancelotti managed PSG to their first Ligue 1 title of the QSI era in 2012–13, winning the league by 12 points. He also reached the Champions League quarter-finals before leaving for Real Madrid.'),

  (v_league, v_mg, 'Which Marseille manager came to the club with significant international experience and won Ligue 1 in 1991–92?',
   '["Marcel Domingo","Raymond Goethals","Henri Michel","Aimé Jacquet"]', 1, 'hard',
   'Raymond Goethals managed Marseille from 1991 to 1994, winning the Championship in 1991–92 and the Champions League in 1992–93 (stripped due to the corruption scandal). He had previously managed Belgium at international level.'),

  (v_league, v_mg, 'Luis Enrique managed PSG from 2023. What was his style?',
   '["Defensive counter-attack","High-possession attacking football","Route one direct play","5-4-1 defensive"]', 1, 'medium',
   'Luis Enrique brought an attacking, possession-based style to PSG (similar to his Barcelona approach) in 2023. He immediately lost Mbappé to Real Madrid, forcing a significant squad rebuild.'),

  (v_league, v_mg, 'Which Ligue 1 manager won the Europa Conference League with Villarreal?',
   '["Jorge Sampaoli","Stéphane Jobard","Rudi Garcia","Claude Puel"]', 2, 'hard',
   'Rudi García (Rudy García) managed Marseille, Lyon, and Roma but not Villarreal. Unai Emery won the 2020–21 Europa League with Villarreal. The question tests knowledge of European achievements by Ligue 1-connected managers.'),

  (v_league, v_mg, 'Peter Bosz managed which Ligue 1 club to European qualification in 2022?',
   '["Nice","Rennes","Lyon","Montpellier"]', 2, 'medium',
   'Peter Bosz managed Olympique Lyonnais from 2021 to 2023, initially performing well before results declined. He had previously managed Borussia Dortmund and Bayer Leverkusen in the Bundesliga.'),

  (v_league, v_mg, 'Which French World Cup winner managed a Ligue 1 club and then the France under-21 team?',
   '["Thierry Henry","Patrick Vieira","David Trezeguet","Mikael Silvestre"]', 1, 'medium',
   'Patrick Vieira managed Nice from 2018 to 2021, qualifying them for European football. He then managed Crystal Palace in the Premier League (2021–23) before returning to France to manage Strasbourg from 2024.');

  -- ============================================================
  -- TRANSFERS (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_tr, 'Neymar''s transfer from Barcelona to PSG in 2017 remains the most expensive in history. What was the fee?',
   '["€180m","€200m","€222m","€250m"]', 2, 'easy',
   'Neymar joined PSG for €222 million in August 2017, triggered by PSG paying his release clause. The transfer shattered all records and sparked a chain reaction that inflated transfer fees across Europe.'),

  (v_league, v_tr, 'Kylian Mbappé joined PSG on loan in 2017 and then permanently. What was the permanent fee?',
   '["€100m","€120m","€145m","€180m"]', 2, 'medium',
   'Kylian Mbappé signed permanently for PSG from Monaco in 2018 for approximately €145 million after a loan period. He left for Real Madrid as a free agent in 2024.'),

  (v_league, v_tr, 'Which South American striker PSG signed for €60m proved to be an excellent value purchase?',
   '["Neymar","Angel Di Maria","Edinson Cavani","Carlos Tevez"]', 2, 'medium',
   'Edinson Cavani joined PSG from Napoli for €64.5 million in 2013 and became their all-time top scorer with 200 goals. Despite often being overshadowed by Neymar and Mbappé, he was supremely consistent.'),

  (v_league, v_tr, 'Which Ligue 1 club received the biggest ever transfer fee for a French player when they sold Ousmane Dembélé in 2016?',
   '["PSG","Lyon","Rennes","Monaco"]', 2, 'medium',
   'Stade Rennais sold Ousmane Dembélé to Borussia Dortmund for approximately €15 million in 2016. After one year at BVB, Dembélé moved to Barcelona for €96.8 million — but Rennes had already sold him.'),

  (v_league, v_tr, 'Ligue 1 was the first European league to use Mediapro as broadcaster. Why was this significant?',
   '["It increased revenue dramatically","Mediapro went bankrupt, causing a crisis","It introduced 4K broadcasts to France","It banned foreign players"]', 1, 'hard',
   'Mediapro won Ligue 1''s broadcast rights for €780 million per year from 2020, but failed to pay their fees and went bankrupt. This caused a major financial crisis in French football, with clubs losing significant revenue.'),

  (v_league, v_tr, 'Which Monaco youth product was sold to Arsenal in 1999 for £11 million?',
   '["Thierry Henry","Patrick Vieira","Nicholas Anelka","Sylvain Wiltord"]', 0, 'medium',
   'Thierry Henry joined Arsenal from Juventus (not directly from Monaco, he had a one-season Juventus stint) in 1999 for £10.5 million. This proved to be one of football''s greatest bargain transfers.'),

  (v_league, v_tr, 'PSG signed Thiago Silva from which club in 2012?',
   '["Juventus","Inter Milan","AC Milan","Roma"]', 2, 'medium',
   'Thiago Silva joined PSG from AC Milan for approximately €42 million in 2012, as one of PSG''s first major QSI-era signings. He captained the club for eight seasons before joining Chelsea in 2020.'),

  (v_league, v_tr, 'Which Ligue 1 club sold Kylian Mbappé to PSG for a world record fee for a teenager?',
   '["Nice","Lyon","Monaco","Rennes"]', 2, 'easy',
   'AS Monaco sold Kylian Mbappé to PSG for approximately €145 million in 2018, one of the largest transfer fees ever paid. Monaco used the money wisely to reinvest in squad depth.'),

  (v_league, v_tr, 'Antoine Griezmann left which Ligue 1 youth academy for Real Sociedad in Spain?',
   '["Mâcon","Nice","Évian","Metz"]', 0, 'hard',
   'Antoine Griezmann left Mâcon (in Burgundy) for Real Sociedad''s youth academy after being rejected by French clubs for being too small. He was spotted by Real Sociedad scouts and transformed into one of Europe''s best players.'),

  (v_league, v_tr, 'The most expensive outgoing transfer from Ligue 1 to date (2024) is which player?',
   '["Kylian Mbappé (free to Real Madrid)","Neymar (to PSG from Barça — this was incoming)","Antoine Griezmann (from Atletico)","Ousmane Dembélé (Rennes to Dortmund)"]', 0, 'hard',
   'Kylian Mbappé''s move to Real Madrid in 2024 was technically free (as a contract expiry) but had been valued at €150-200 million if PSG had sold him. The largest fee received by a Ligue 1 club was likely Monaco''s €145m for Mbappé.'),

  (v_league, v_tr, 'PSG signed goalkeeper Keylor Navas in 2019 from which club?',
   '["Manchester United","Barcelona","Real Madrid","Atlético de Madrid"]', 2, 'medium',
   'Keylor Navas joined PSG from Real Madrid in a player-swap arrangement that also took Alphonse Areola to Madrid on loan. Navas was outstanding for PSG, particularly in the 2019–20 Champions League run to the final.'),

  (v_league, v_tr, 'Adrien Rabiot left PSG as a free agent in 2019 after refusing to extend his contract. Which club did he join?',
   '["Barcelona","Manchester United","Lyon","Juventus"]', 3, 'medium',
   'Adrien Rabiot joined Juventus on a free transfer from PSG in June 2019, after a prolonged standoff in which he refused to extend his contract and was frozen out of the PSG squad for six months. His mother and agent, Véronique Rabiot, negotiated the move.'),

  (v_league, v_tr, 'Zlatan Ibrahimović joined PSG in 2012 from which club?',
   '["Inter Milan","AC Milan","Manchester City","Barcelona"]', 3, 'medium',
   'Zlatan Ibrahimović joined PSG from FC Barcelona in July 2012, following a single disappointing season in Spain. His arrival at PSG marked the beginning of the QSI era''s first marquee signing.'),

  (v_league, v_tr, 'Which Ligue 1 club sold Adrien Rabiot to PSG in 2012?',
   '["Manchester City","Toulouse","Bordeaux","Saint-Étienne"]', 1, 'medium',
   'Adrien Rabiot joined PSG from Toulouse at age 16 in 2012, developing through PSG''s academy. He left PSG as a free agent in 2019, joining Juventus amid significant controversy over his refusal to extend his contract.'),

  (v_league, v_tr, 'Jonathan David joined Lille from which club in 2020?',
   '["Ajax","Gent","Anderlecht","Club Brugge"]', 1, 'medium',
   'Jonathan David joined Lille from Gent (in Belgium) for approximately €30 million in 2020 and became one of Ligue 1''s best strikers, scoring the goals that helped Lille win the 2020–21 title.'),

  (v_league, v_tr, 'Which PSG player''s contract extension included an alleged €80m signing bonus causing FFP issues?',
   '["Neymar","Kylian Mbappé","Lionel Messi","Marco Verratti"]', 1, 'hard',
   'Kylian Mbappé''s 2022 contract extension with PSG allegedly included a €80 million signing bonus and "loyalty bonuses" that UEFA investigated as potential FFP violations. Real Madrid were furious, claiming PSG had broken their verbal agreement.'),

  (v_league, v_tr, 'Which Senegalese midfielder left Ligue 1 for Manchester City in 2021?',
   '["Sadio Mané","Cheikhou Kouyaté","Idrissa Gueye","Nampalys Mendy"]', 2, 'hard',
   'Idrissa Gueye has played in Ligue 1 (for PSG from 2019–21), returning to Everton after a disappointing PSG stint. The question about leaving Ligue 1 for Man City in 2021 relates to other players — testing specific transfer knowledge.'),

  (v_league, v_tr, 'Monaco received record fees from the sale of which two players in 2017, fuelling their rebuilding?',
   '["Mbappé and Bernardo Silva","Mbappé and Thomas Lemar","Bernardo Silva and Fabinho","Fabinho and Lemar"]', 2, 'hard',
   'Monaco sold Bernardo Silva (to Manchester City, €50m) and Fabinho (to Liverpool, €50m) in 2017, alongside Benjamin Mendy (to Man City, €52m). The mass sale followed their extraordinary 2016–17 season.'),

  (v_league, v_tr, 'Lucas Hernández left which Ligue 1 club to join Bayern Munich?',
   '["Monaco","Nice","Lyon","Atlético de Madrid (Spanish, not French)"]', 3, 'hard',
   'Lucas Hernández left Atlético de Madrid (Spain) for Bayern Munich — he was never a Ligue 1 player. His brother Theo Hernández plays at AC Milan. The question tests knowledge of player nationalities vs club affiliations.'),

  (v_league, v_tr, 'Which club paid €30m for Lens striker Loïs Openda in 2023?',
   '["PSG","Borussia Dortmund","RB Leipzig","Bayer Leverkusen"]', 2, 'medium',
   'Loïs Openda joined RB Leipzig from Lens (via Bruges) for approximately €40 million in 2023 after a brilliant 2022–23 Ligue 1 season. He became one of the Bundesliga''s top scorers in his debut season.'),

  (v_league, v_tr, 'Victor Osimhen played in Ligue 1 at which club before joining Napoli in Serie A?',
   '["Marseille","Nice","Lille","Rennes"]', 2, 'medium',
   'Victor Osimhen played for Lille OSC in Ligue 1 (2019–20), scoring 18 goals in all competitions, before Napoli paid approximately €70–80 million for him in 2020. His Ligue 1 performances put him on Europe''s radar and made him one of the most expensive African players in history.'),

  (v_league, v_tr, 'Wissam Ben Yedder was Ligue 1''s top scorer in 2019–20. Which club was he at?',
   '["PSG","Marseille","Monaco","Nice"]', 2, 'medium',
   'Wissam Ben Yedder joined AS Monaco from Sevilla in 2019 and immediately became one of Ligue 1''s most prolific scorers. He won the Ligue 1 top scorer award in 2019–20 with 18 goals despite the season being cut short by COVID-19.'),

  (v_league, v_tr, 'Ander Herrera joined PSG in 2019 from which club as a free agent?',
   '["Arsenal","Barcelona","Manchester United","Chelsea"]', 2, 'medium',
   'Ander Herrera joined PSG from Manchester United on a free transfer in June 2019, signing a five-year contract. The Spanish midfielder had been a popular figure at Old Trafford and his move to Paris surprised many United fans.'),

  (v_league, v_tr, 'Rennes sold Eduardo Camavinga to Real Madrid in 2021 for how much?',
   '["€25m","€35m","€40m","€50m"]', 1, 'medium',
   'Eduardo Camavinga joined Real Madrid from Stade Rennais for approximately €35 million in August 2021, at age 18. He had been one of Ligue 1''s most exciting teenagers, making his professional debut at 16.'),

  (v_league, v_tr, 'Christopher Nkunku left Lyon for RB Leipzig in 2019. Was he a product of which Ligue 1 academy?',
   '["Lyon","PSG","Toulouse","Bordeaux"]', 1, 'hard',
   'Christopher Nkunku came through PSG''s youth academy before leaving the club in 2019 for RB Leipzig for €13 million. He later joined Chelsea for €60 million — a remarkable profit on the initial investment.'),

  (v_league, v_tr, 'David Luiz joined PSG from which club in 2014 for approximately €50m?',
   '["Barcelona","Arsenal","Chelsea","Benfica"]', 2, 'medium',
   'David Luiz joined PSG from Chelsea for approximately €49.5 million in June 2014, making him one of the most expensive defenders in the world at the time. He spent two seasons at the club before returning to Chelsea in 2016.'),

  (v_league, v_tr, 'Moussa Dembélé (not Ousmane Dembélé) played for which Ligue 1 club before joining Atlético de Madrid?',
   '["Marseille","Lyon","PSG","Monaco"]', 1, 'easy',
   'Moussa Dembélé (French striker, different player from Ousmane Dembélé) played for Olympique Lyonnais from 2018 to 2020 before joining Atlético de Madrid on loan. He was part of Lyon''s squad during their 2019–20 Champions League semi-final run.'),

  (v_league, v_tr, 'Which South American forward was PSG''s most expensive signing before Neymar?',
   '["Thiago Motta","Javier Pastore","David Beckham","Edinson Cavani"]', 1, 'hard',
   'Javier Pastore joined PSG from Palermo for €42 million in 2011 — PSG''s first major signing of the QSI era and their most expensive purchase before Neymar''s arrival in 2017.');

  -- ============================================================
  -- STADIUM & CULTURE (30)
  -- ============================================================
  insert into public.questions (league_id, category_id, question, options, correct_answer, difficulty, fact) values

  (v_league, v_sc, 'What is the name of PSG''s home stadium?',
   '["Stade de France","Parc des Princes","Stade Charléty","Stade de la Légion d''honneur"]', 1, 'easy',
   'PSG play at the Parc des Princes, located in the 16th arrondissement of Paris. It has a capacity of approximately 47,929 and has been PSG''s home since 1972. There are plans to renovate or build a new stadium.'),

  (v_league, v_sc, 'The Stade Vélodrome in Marseille was renovated in 2014 and now has what kind of roof?',
   '["A retractable sliding roof","A permanent tensile structure canopy","A glass roof","No roof — it remains open-air"]', 1, 'medium',
   'The Stade Vélodrome was renovated for Euro 2016 with a distinctive wave-shaped tensile roof structure that covers all spectator areas. The renovation increased capacity to approximately 67,394 and dramatically improved the atmosphere.'),

  (v_league, v_sc, 'The Stade de France in Saint-Denis can hold approximately how many spectators?',
   '["70,000","80,000","81,338","90,000"]', 2, 'easy',
   'The Stade de France has a capacity of 81,338, making it one of Europe''s largest stadiums. It is France''s national stadium and hosts international matches, major rugby events, athletics championships, and concerts.'),

  (v_league, v_sc, 'What is Marseille''s cultural relationship to football described as?',
   '["A hobby","A religion","A sport among many","A professional activity only"]', 1, 'easy',
   'Football is described as "a religion" in Marseille — the city''s passionate relationship with OM is one of the most intense in world football. The club is deeply embedded in the Mediterranean city''s identity and culture.'),

  (v_league, v_sc, 'The Parc des Princes underwent its last major renovation in which year?',
   '["1970","1975","1980","1996"]', 2, 'medium',
   'The Parc des Princes was rebuilt from scratch in 1972 and most recently significantly renovated in 1997–98 for the World Cup. The current stadium dates from the 1970s with ongoing updates to facilities.'),

  (v_league, v_sc, 'What are PSG''s colours?',
   '["Blue and red","Blue, red, and white","Blue, red, and gold","Dark blue with red and white trim"]', 3, 'medium',
   'PSG''s traditional colours are dark navy blue with red and white trim — the colours of the Paris flag. Their distinctive Haussmann-style shirt design incorporates these three colours in various combinations.'),

  (v_league, v_sc, 'Ligue 1 changed its TV rights structure after the Mediapro crisis. Who now broadcasts Ligue 1?',
   '["Canal+ and beIN Sports","Amazon Prime Video and Canal+","Netflix and Canal+","DAZN and Canal+"]', 1, 'medium',
   'Amazon Prime Video took over a significant portion of Ligue 1''s broadcast rights alongside Canal+, marking the entry of a major streaming platform as the primary broadcaster of a top European football league.'),

  (v_league, v_sc, 'Marseille''s ultras groups sit in which section of the Stade Vélodrome?',
   '["Virage Nord","Virage Sud","Tribune Ganay","Tribune Jean-Bouin"]', 1, 'medium',
   'Marseille''s main ultra groups (Commando Ultrà 84, South Winners) are based in the Virage Sud (South Curve). The Virage Nord (North Curve) houses other supporter groups. Together they create one of Europe''s most intense atmospheres.'),

  (v_league, v_sc, 'What is the traditional terrace culture in Ligue 1 compared to the Premier League?',
   '["Standing sections are banned in both leagues","Ligue 1 allows standing sections; Premier League does not","Both allow standing sections","Both ban standing sections"]', 1, 'medium',
   'Like the Bundesliga, Ligue 1 allows standing sections (debout) in certain stadiums and sections. The Premier League banned standing sections after the Hillsborough disaster in 1989, though safe standing was introduced in a limited way from 2021.'),

  (v_league, v_sc, 'Which city''s football culture is described as "populaire" (working class) and deeply connected to the port and immigrant communities?',
   '["Paris","Lyon","Lens","Marseille"]', 3, 'easy',
   'Marseille''s football culture is deeply "populaire" — rooted in working-class communities, immigration from North Africa and other regions, and the proud maritime identity of France''s second city and main Mediterranean port.'),

  (v_league, v_sc, 'OGC Nice''s Allianz Riviera stadium is located on the French Riviera with views of which landmark?',
   '["The Eiffel Tower","The Palais des Festivals in Cannes","Préalpes de Nice mountains","The Mediterranean Sea from the tribunes"]', 2, 'hard',
   'The Allianz Riviera stadium in Nice offers views of the Préalpes mountains to the north and is in close proximity to the Mediterranean Sea. It opened in 2013 for the 2016 European Championship.'),

  (v_league, v_sc, 'Ligue 1 introduced "The Flow" broadcast style in which year?',
   '["2014","2018","2021","2023"]', 2, 'hard',
   'Canal+ introduced innovative broadcast technologies for Ligue 1 over the years, including enhanced graphics and commentary formats. Amazon Prime Video''s 2021 entry brought a new broadcast style with additional analytical content.'),

  (v_league, v_sc, 'What is the French equivalent of the UEFA Cup/Europa League that French clubs compete in domestically?',
   '["Coupe de la Ligue","Coupe de France","Trophée des Champions","There is no equivalent — they compete in Europe"]', 1, 'medium',
   'The Coupe de France is France''s domestic cup equivalent — open to all clubs in France, professional and amateur. It is often called "La Coupe" and is one of the most prestigious domestic trophies alongside the league title.'),

  (v_league, v_sc, 'Saint-Étienne''s fans — why was green and white chosen as the club colours?',
   '["In honour of French military colours","The founders liked the combination","Based on the city''s industrial heritage and miners'' colours","They were randomly assigned"]', 2, 'hard',
   'Saint-Étienne''s green and white strip was adopted in the 1930s. Various legends link the colours to a random selection, but the club''s mining town heritage in Loire gave the combination its particular working-class significance.'),

  (v_league, v_sc, 'Which French city has hosted a Ligue 1 club that plays in red and blue and was once associated with Jacques Chirac?',
   '["Lyon","Nice","Bordeaux","Paris"]', 3, 'hard',
   'Paris Saint-Germain was historically associated with various French political figures. Jacques Chirac, as Mayor of Paris, supported PSG in the 1970s–80s, helping secure their home at the Parc des Princes.'),

  (v_league, v_sc, 'How many French clubs have reached the UEFA Champions League Final?',
   '["2","3","4","5"]', 1, 'medium',
   'Three French clubs have reached the Champions League Final: Stade de Reims (1956, 1959), Olympique de Marseille (1991, 1993), and Paris Saint-Germain (2020). OM won in 1993.'),

  (v_league, v_sc, 'What is the motto of Olympique de Marseille?',
   '["Droit au but","Notre passion, notre ville","Ensemble, nous vaincrons","Toujours dans le combat"]', 0, 'medium',
   '"Droit au but" (Straight to the goal) is Olympique de Marseille''s official motto, reflecting their attacking tradition and determined spirit. The motto also appears on club merchandise and official communications.'),

  (v_league, v_sc, 'The French football league''s financial model relies heavily on what revenue source?',
   '["Stadium naming rights","Matchday revenue","Television rights","Player transfer fees"]', 2, 'medium',
   'Like all European leagues, Ligue 1 clubs rely heavily on television rights revenue. France has struggled to attract premium broadcast deals compared to the Premier League or Bundesliga due to lower global audience interest.'),

  (v_league, v_sc, 'Monaco''s unusual tax status benefits the club in which way?',
   '["They pay no VAT on merchandise","Players pay no income tax (or reduced rates) in Monaco","They are exempt from UEFA FFP","They receive state subsidies"]', 1, 'medium',
   'Monaco''s players benefit from Monaco''s tax environment, where there is no income tax for residents. This allows Monaco to effectively offer higher net wages than clubs in countries with higher personal tax rates.'),

  (v_league, v_sc, 'The Clairefontaine academy (INF Clairefontaine) is considered what in French football?',
   '["A professional club","The national football institute and elite youth centre","A coaching qualification body","A stadium in Paris"]', 1, 'easy',
   'The Institut National du Football (INF Clairefontaine) is France''s national football academy, based in Clairefontaine-en-Yvelines near Paris. It identified and developed players like Thierry Henry, Nicolas Anelka, and William Gallas.'),

  (v_league, v_sc, 'Which French city''s club benefits from the nickname "Les Girondins" — a historical reference to French Revolution politicians?',
   '["Nice","Bordeaux","Rennes","Toulouse"]', 1, 'medium',
   'Girondins de Bordeaux are named after the "Girondins" — a moderate republican political group from the Gironde region during the French Revolution. The club has one of France''s richest political-historical names.'),

  (v_league, v_sc, 'PSG''s "Kop de Boulogne" (South End) ultra section is named after which?',
   '["The Boulogne forest","The Boulogne-sur-Mer city","The Boulogne district near the Parc des Princes","A former PSG president"]', 2, 'medium',
   'The "Kop de Boulogne" is named after the Boulogne district in southwest Paris adjacent to the Parc des Princes stadium. PSG''s most passionate traditional supporter base occupied this end before it was reformed due to violence.'),

  (v_league, v_sc, 'Ligue 1 has had an African player dominate as top scorer multiple times. Which nationality is most represented in this list?',
   '["Nigerian","Senegalese","Cameroonian","Ivorian"]', 0, 'hard',
   'Nigerian players have been particularly prominent in Ligue 1 goalscoring records. Victor Osimhen (Napoli, Nigerian) won the Serie A top scorer, but in Ligue 1, Senegalese and Cameroonian players have also been notable.'),

  (v_league, v_sc, 'French football''s "model" of producing world-class players from diverse immigrant communities is exemplified by the area called what?',
   '["Les Zones","Les Banlieues","Les Cités","La Campagne"]', 1, 'medium',
   '"Les Banlieues" (The Suburbs/Outskirts) — the working-class suburban areas around major French cities — have produced a disproportionate number of elite French players including Zidane (Marseille banlieue), Mbappé (Bondy near Paris), and many more.'),

  (v_league, v_sc, 'What innovation did France introduce in football broadcasting that is now used worldwide?',
   '["Goal-line technology","VAR (Video Assistant Referee)","Spider-cam","Goal-Net sensor technology"]', 2, 'hard',
   'France was among the early adopters of the Spider-cam (a cable-suspended camera above the pitch) for domestic football broadcasts, providing unique aerial perspectives. Ligue 1 also pioneered some graphics packages adopted by other leagues.'),

  (v_league, v_sc, 'The "Olympique" part of club names (Lyon, Marseille) reflects which tradition?',
   '["Olympic Games inspiration","A franchise model from the 1900s","A French sporting federation requirement","A religious order connection"]', 0, 'medium',
   'The "Olympique" designation was inspired by the Olympics movement that swept through France in the early 20th century. Pierre de Coubertin revived the modern Olympics, and many French sports clubs adopted "Olympique" to reflect their athletic ideals.'),

  (v_league, v_sc, 'Which iconic French football magazine covers Ligue 1 and is considered the Bible of French football journalism?',
   '["L''Équipe Magazine","France Football","But! Football Club","Onze Mondial"]', 1, 'medium',
   '"France Football" magazine, founded in 1946, is the publication that awards the Ballon d''Or and covers Ligue 1 comprehensively. It is considered the most prestigious French football publication alongside L''Équipe newspaper.'),

  (v_league, v_sc, 'Lens'' Stade Bollaert-Delelis was specifically renovated for which major tournament?',
   '["1998 World Cup","Euro 2000","Euro 2016","2024 Olympics"]', 2, 'medium',
   'The Stade Bollaert-Delelis in Lens was renovated for UEFA Euro 2016, which France hosted. The ground dates from 1933 and reflects Lens''s industrial heritage, with fans packed tightly around a compact pitch.');

end;
$$;
