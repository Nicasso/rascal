 module lang::rascal::tests::functionality::BacktrackingTests
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
   *  *  Bert Lisser - Bert.Lisser@cwi.nl - CWI
  *******************************************************************************/
  
// testSimple
  	
test bool testSimple1() = int i <- [1,4] && int k := i && k >= 4;
test bool testSimple2() = int i <- [1,4] && int j <- [2,1] && int k := i + j && k >= 5;
  	
// testList
  		
test bool testList1() = ([*int L1, int N, *int L2] := [1,2,3,4]) && (N == 3) && 
  					    (L1 == [1,2]) && (N == 3) && (L2 == [4]);
  		
test bool testList2() = ([*int L1, int N, *int L2] := [1,2,3,4]) && ((N == 3) || (N==4)) &&  
  		                (L1 == [1,2]) && (N == 3) && (L2 == [4]);
  		
test bool testList3() = ([*int L1, int N, *int L2] := [1,2,3,4]) && 
  			            ([*int L3, int M, *int L4] := [3,4]) && (N > M) &&  (N == 4);
  
test bool testList4() = [1, [*int P, int N, *int Q], 3] := [1, [1,2,3,2], 3];
test bool testList5() = [*int P, int N, *int Q]:= [1,2,3,2] && N > 1;
  		
test bool testList6() = [1, [*int P, int N, *int Q], 3] := [1, [10,20], 3] && N > 10;
  	
// testSet
  		
test bool testSet1() = ({*int S1, int N} := {1,2,3,4}) && (N == 1);
test bool testSet2() = ({*int S1, int N} := {1,2,3,4}) && (N == 2);
test bool testSet3() = ({*int S1, int N} := {1,2,3,4}) && (N == 3);
test bool testSet4() = ({*int S1, int N} := {1,2,3,4}) && (N == 4);
  	
test bool testSet5() = ({*int S1, int N, *int S2} := {1,2,3,4}) && (N == 1);
test bool testSet6() = ({*int S1, int N, *int S2} := {1,2,3,4}) && (N == 2);
test bool testSet7() = ({*int S1, int N, *int S2} := {1,2,3,4}) && (N == 3);
test bool testSet8() = ({*int S1, int N, *int S2} := {1,2,3,4}) && (N == 4);
  		
test bool testSet9() = {1, {*int S1, int N}, 3} := {1, {1,2,3}, 3};
test bool testSet10() = {*int S1, int N}:= {1,2,3,2} && N == 1;
test bool testSet11() = {*int S1, int N}:= {1,2,3,2} && N == 2;
test bool testSet12() = {*int S1, int N}:= {1,2,3,2} && N == 3;
  		
test bool testSet13() = {1, {*int S1, int N, *int S2}, 3} := {1, {1,2,3}, 3};
test bool testSet14() = {1, {*int S1, int N, *int S2}, 3} := {1, {1,2,3}, 3} && N == 1;
test bool testSet15() = {1, {*int S1, int N, *int S2}, 3} := {1, {1,2,3}, 3} && N == 2;
test bool testSet16() = {1, {*int S1, int N, *int S2}, 3} := {1, {1,2,3}, 3} && N == 3;
  	
// and
  
test bool and1() = int i <- [0, 1] && ["a","b"][i] == "a";
test bool and2() = int i <- [0, 1] && ["a","b"][i] == "b";

 