module lang::css::m3::TypeSymbol

extend analysis::m3::TypeSymbol;
/**
 * Not really sure when this is used yet...
 * Not sure if all align with the jStyleParser but it's something... 
 * Source: https://developer.mozilla.org/en-US/docs/tag/CSS%20Data%20type
 */
data TypeSymbol 
  = \angle()
  | \basicShape()
  | \blendMode()
  | \colorValue()
  | \customIdent()
  | \gradient()
  | \image()
  | \integer()
  | \length()
  | \number()
  | \percentage()
  | \positionValue()
  | \ratio()
  | \resolution()
  | \shape()
  | \shapeBox()
  | \string()
  | \time()
  | \timingFunction()
  | \transformFunction()
  ;