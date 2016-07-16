 module lang::rascal::tests::library::analysis::graphs::GraphTests
  /*******************************************************************************
   * Copyright (c) 2009-2015 CWI
   * All rights reserved. This program and the accompanying materials
   * are made available under the terms of the Eclipse Public License v1.0
   * which accompanies this distribution, and is available at
   * http://www.eclipse.org/legal/epl-v10.html
   *
   * Contributors:
  
   *   * Jurgen J. Vinju - Jurgen.Vinju@cwi.nl - CWI
   *   * Paul Klint - Paul.Klint@cwi.nl - CWI
   *   * Bert Lisser - Bert.Lisser@cwi.nl - CWI
  *******************************************************************************/
 import analysis::graphs::Graph;
 
 
import analysis::graphs::Graph;


/*
              1 -----> 3
              |        |
              v        |
              2        |
              |        |
              v        |
              4 <------+

*/
public Graph[int] G1 = {<3,4>, <1,2>, <2,4>, <1,3>};

/*
               1
               |
               v
               2 <----> 3
               ^        ^
               |        |
               v        v
               4 <----> 5

*/

public Graph[int] G2 = {<1, 2>, <2, 3>, <3, 2>, <2, 4>, <4, 2>, <3, 5>, <5, 3>, <4, 5>, <5, 3>};


/*
               1------->6------>7<---->8
               | 
               v
               2 <----> 3
               ^        ^
               |        |
               v        v
               4 <----> 5

*/

public Graph[int] G3 = {<1, 2>, <2, 3>, <3, 2>, <2, 4>, <4, 2>, <3, 5>, <5, 3>, <4, 5>, <5, 3>, <1,6>, <6,7>, <7,8>,<8,7>}; 
  
// bottom
  
test bool bottom1() = bottom({}) == {};
test bool bottom2() = bottom({<1,2>, <1,3>, <2,4>, <3,4>}) == {4};
test bool bottom3() = bottom(G1) == {4};
test bool bottom4() = bottom(G2) == {};
test bool bottom5() = bottom(G3) == {};

// TODO: connectedComponents

// order

test bool order1() = order(G1) == [1,3,2,4];
test bool order2() = order(G2)[0] == 1;
test bool order3() = order(G3)[0] == 1 &&  order(G3)[1] == 6;

// predecessors
  
test bool predecessors1()=  predecessors({<1,2>, <1,3>, <2,4>, <3,4>}, 4) =={2, 3};
test bool predecessors2() = predecessors(G1, 2) == {1};
test bool predecessors3() = predecessors(G1, 4) == {2,3};
test bool predecessors4() = predecessors(G2, 2) == {1,3,4};
test bool predecessors5() = predecessors(G2, 5) == {3,4};
test bool predecessors6() = predecessors(G3, 8) == {7};
test bool predecessors7() = predecessors(G3, 5) == {3,4};
  
// reachR()
  
test bool reachR1() = reachR({}, {}, {}) == {};
test bool reachR2() = reachR({<1,2>, <1,3>, <2,4>, <3,4>}, {1}, {}) =={};
test bool reachR3() = reachR({<1,2>, <1,3>, <2,4>, <3,4>}, {1}, {1,2}) =={2};
test bool reachR4() = reachR({<1,2>, <1,3>, <2,4>, <3,4>}, {1}, {1,2,3}) =={2,3};
test bool reachR5() = reachR({<1,2>, <1,3>, <2,4>, <3,4>}, {1}, {1,2,4}) =={2, 4};
  
// reachX
  
test bool reachX1() = reachX({}, {}, {}) == {};
test bool reachX() = reachX({<1,2>, <1,3>, <2,4>, <3,4>}, {1}, {}) =={2, 3, 4};
test bool reachX2() = reachX({<1,2>, <1,3>, <2,4>, <3,4>}, {1}, {2}) =={3, 4};
test bool reachX() = reachX({<1,2>, <1,3>, <2,4>, <3,4>}, {1}, {2,3}) =={};
test bool reachX3() = reachX({<1,2>, <1,3>, <2,4>, <3,4>}, {1}, {4}) =={2, 3};
  	
// reach
  
test bool reach0() = reach({}, {}) == {};
test bool reach1() = reach({<1,2>, <1,3>, <2,4>, <3,4>}, {1}) =={1,2, 3, 4};
test bool reach2() = reach({<1,2>, <1,3>, <2,4>, <3,4>}, {2}) =={2, 4};
test bool reach3() = reach({<1,2>, <1,3>, <2,4>, <3,4>}, {3}) =={3, 4};
test bool reach4() = reach({<1,2>, <1,3>, <2,4>, <3,4>}, {4}) =={4};
test bool reach5() = reach({<1,2>, <1,3>, <2,4>, <3,4>}, {3,4}) =={3,4};
test bool reach6() = reach({<1,2>, <1,3>, <2,4>, <3,4>}, {2,3}) =={2, 3,4};
  	
// TODO: shortestPathPair
  	
// successors
  
test bool successors1() = successors({<1,2>, <1,3>, <2,4>, <3,4>}, 1) =={2, 3};
test bool successors2() = successors(G1, 3) == {4};
test bool successors3() = successors(G1, 1) == {2,3};
test bool successors4() = successors(G2, 1) == {2};
test bool successors5() = successors(G3, 2) == {3,4};

// top
  
test bool top1() = top({}) == {};
test bool top2() = top({<1,2>, <1,3>, <2,4>, <3,4>}) == {1};
test bool top3() = top(G1) == {1};
test bool top4() = top(G2) == {1};
test bool top5() = top(G3) == {1};