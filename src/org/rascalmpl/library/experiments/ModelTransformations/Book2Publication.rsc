module experiments::ModelTransformations::Book2Publication

/*
 * Example taken from "ATL Basic Examples and Patterns" at
 * http://www.eclipse.org/m2m/atl/basicExamples_Patterns/
 *
 * See http://www.eclipse.org/m2m/atl/atlTransformations/#Book2Publication
 */

// Source model: Book

data Chapter = chapter(str title, int nbPages);
data Book = book(str title, list[Chapter] chapters);

// Target model: Publication

data Publication = publication(str title, int nbPages);

// book2publication

public Publication book2publication(Book b){
  int nbPages = 0;
  for(c <- b.chapters)
    nbPages += c.nbPages;
  return publication(b.title, nbPages);
}

// Tests


private Book input = book("The Unbearable Lightness of Being", 
                    [ chapter("PART ONE Lightness and Weight", 36), 
                     chapter("PART TWO Soul and Body", 42), 
                     chapter("PART THREE Words Misunderstood", 50), 
                     chapter("PART FOUR Soul and Body", 44), 
                     chapter("PART FIVE Lightness and Weight", 68), 
                     chapter("PART SIX The Grand March", 38), 
                     chapter("PART SEVEN Karenin\'s Smile", 30)
                    ]);
               
private Publication output = publication("The Unbearable Lightness of Being", 308);
  
test book2publication(input) == output;
