module \Bool-examples1

import languages/Booleans/syntax;

Bool reduce(Bool B) {
    Bool B1, B2;
    return bottom-up visit(B) {
      case true & <B2>   => <B2>;
      case false & <B2>  => false;

      case true | true   => true;
      case true | false  => true;
      case false | true  => true;
      case false | false => false;
    };
}