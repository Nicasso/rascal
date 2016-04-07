package org.rascalmpl.library.lang.css.m3.internal;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.library.lang.java.m3.internal.IValueList;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.type.TypeStore;

import cz.vutbr.web.css.CombinedSelector;
import cz.vutbr.web.css.Declaration;
import cz.vutbr.web.css.MediaExpression;
import cz.vutbr.web.css.MediaQuery;
import cz.vutbr.web.css.Rule;
import cz.vutbr.web.css.RuleBlock;
import cz.vutbr.web.css.RuleFontFace;
import cz.vutbr.web.css.RuleMargin;
import cz.vutbr.web.css.RuleMedia;
import cz.vutbr.web.css.RulePage;
import cz.vutbr.web.css.RuleSet;
import cz.vutbr.web.css.RuleViewport;
import cz.vutbr.web.css.Selector;
import cz.vutbr.web.css.Selector.ElementAttribute;
import cz.vutbr.web.css.Selector.ElementClass;
import cz.vutbr.web.css.Selector.ElementDOM;
import cz.vutbr.web.css.Selector.ElementID;
import cz.vutbr.web.css.Selector.ElementName;
import cz.vutbr.web.css.StyleSheet;
import cz.vutbr.web.css.Term;
import cz.vutbr.web.css.TermAngle;
import cz.vutbr.web.css.TermColor;
import cz.vutbr.web.css.TermExpression;
import cz.vutbr.web.css.TermFrequency;
import cz.vutbr.web.css.TermFunction;
import cz.vutbr.web.css.TermIdent;
import cz.vutbr.web.css.TermInteger;
import cz.vutbr.web.css.TermLength;
import cz.vutbr.web.css.TermLengthOrPercent;
import cz.vutbr.web.css.TermList;
import cz.vutbr.web.css.TermNumber;
import cz.vutbr.web.css.TermPair;
import cz.vutbr.web.css.TermPercent;
import cz.vutbr.web.css.TermResolution;
import cz.vutbr.web.css.TermString;
import cz.vutbr.web.css.TermTime;
import cz.vutbr.web.css.TermURI;

public class ASTConverter extends CSSToRascalConverter {
	
	private IEvaluatorContext eval;
	
	public ASTConverter(Collection<RuleBlock<?>> rules, TypeStore store, IEvaluatorContext eval) {
		super(store, new HashMap<>());
		this.eval = eval;
		
		rulesBlock(rules);
	}

	private void rulesBlock(Collection<RuleBlock<?>> rules) {
		for (RuleBlock<?> ruleBlock : rules) {
			if (ruleBlock instanceof RuleSet) {
				ruleSet(ruleBlock);
			} else if (ruleBlock instanceof RuleMedia) {
				ruleMedia(ruleBlock);
			} else if (ruleBlock instanceof RuleFontFace) {
				ruleFontFace(ruleBlock);
			} else if (ruleBlock instanceof RuleMargin) {
				ruleMargin(ruleBlock);
			} else if (ruleBlock instanceof RulePage) {
				rulePage(ruleBlock);
			} else if (ruleBlock instanceof RuleViewport) {
				ruleViewport(ruleBlock);
			} else {
				new AssertionError("Some kind of exotic block which is not recognized.");
			}
		}
	}

	private void ruleSet(RuleBlock<?> ruleBlock) {
		eval.getStdOut().println("This is a ruleblock");
		eval.getStdOut().println("");
		RuleSet set = (RuleSet) ruleBlock;		
		selectors(set.getSelectors());

		eval.getStdOut().println("Declarations:");
		for (Declaration decl : set) {
			eval.getStdOut().println("  Property: " + decl.getProperty());
			eval.getStdOut().println("  Values: ");
			declarations(decl);
		}
	}
	
	private void mediaQuery(List<MediaQuery> list) {
		for(MediaQuery m : list) {
			eval.getStdOut().println("MEDIAQUERY: "+m.getType()+" - "+m.toString());
			mediaExpression(m);
		}
	}
	
	private void mediaExpression(MediaQuery m) {
		for(MediaExpression a : m) {
			eval.getStdOut().println("MEDIAEXPRESSION: "+a.getFeature() + " - " +a.toString());
			mediaTerms(a);
		}
	}
	
	private void mediaTerms(MediaExpression m) {
		for(Term a : m) {
			eval.getStdOut().println("(MEDIA)TERMS: "+a.toString());
			terms(a);
		}
	}

	private void ruleMedia(RuleBlock<?> ruleBlock) {
		eval.getStdOut().println("");
		eval.getStdOut().println("This is a ruleMedia");
		RuleMedia media = (RuleMedia) ruleBlock;
		mediaQuery(media.getMediaQueries());
		for (RuleSet set : media) {
			ruleSet(set);
		}
	}

	private void ruleFontFace(RuleBlock<?> ruleBlock) {
		eval.getStdOut().println("This is a ruleFontFace");
		eval.getStdOut().println("");
		RuleFontFace media = (RuleFontFace) ruleBlock;
		//eval.getStdOut().println("FontFace" + media.f);
		for (Declaration set : media) {
			declarations(set);
		}
	}

	private void ruleMargin(RuleBlock<?> ruleBlock) {
		eval.getStdOut().println("This is a ruleMargin");
		eval.getStdOut().println("");
		RuleMargin media = (RuleMargin) ruleBlock;
		eval.getStdOut().println("Magins: " + media.getMarginArea());
		for (Declaration set : media) {
			declarations(set);
		}
	}

	private void rulePage(RuleBlock<?> ruleBlock) {
		eval.getStdOut().println("This is a rulePage");
		eval.getStdOut().println("");
		RulePage media = (RulePage) ruleBlock;
		eval.getStdOut().println("Name: " + media.getName());
		for (Rule<?> set : media) {
			rules(set);
		}
	}

	private void ruleViewport(RuleBlock<?> ruleBlock) {
		eval.getStdOut().println("This is a ruleViewport");
		eval.getStdOut().println("");
		RuleViewport media = (RuleViewport) ruleBlock;
		for (Declaration set : media) {
			declarations(set);
		}
	}
	
	private void realSelectors(CombinedSelector s2) {
		for (Selector s : s2) {
			for (Selector.SelectorPart sp : s) {
				eval.getStdOut().print(sp.toString() + " ");
				//eval.getStdOut().println("Complete selector: ."+s.getClassName()+" - "+s.getElementName()+" - #"+s.getIDName()+" - "+s.getCombinator());
			}
		}
		eval.getStdOut().println("");
	}
	
	private void mediaExpression(MediaExpression exp) {
		eval.getStdOut().println("mediaExpression: "+exp.getFeature());
		
	}
	
	private void mediaQuery(MediaQuery q) {
		eval.getStdOut().println("mediaQuery: "+q.getType());
	}

	private void rules(Rule<?> rules) {
		eval.getStdOut().println("Rules:");
		for (Object rule : rules) {
			if (rule instanceof CombinedSelector) {
				//realSelectors((Collection<Selector.SelectorPart>) rule);
			} else if (rule instanceof Declaration) {
				declarations((Declaration) rule);
			} else if (rule instanceof MediaExpression) {
				mediaExpression((MediaExpression) rule);
			} else if (rule instanceof MediaQuery) {
				mediaQuery((MediaQuery) rule);
			} else if (rule instanceof RuleBlock) {
				rulesBlock((RuleBlock) rule);
			} else if (rule instanceof RuleFontFace) {
				ruleFontFace((RuleFontFace) rule);
			} else if (rule instanceof RuleMargin) {
				ruleMargin((RuleMargin) rule);
			} else if (rule instanceof RulePage) {
				rulePage((RulePage) rule);
			} else if (rule instanceof RuleSet) {
				ruleSet((RuleSet) rule);
			} else if (rule instanceof RuleViewport) {
				ruleViewport((RuleViewport) rule);
			} else if (rule instanceof Selector) {
				selectors((CombinedSelector[]) rule);
			} else if (rule instanceof StyleSheet) {
				rulesBlock((Collection<RuleBlock<?>>) rule);
			}
			//eval.getStdOut().println("");
		}
	}

	private void declarations(Declaration decl) {
		eval.getStdOut().println("Important? "+decl.isImportant());
		for (Term<?> term : decl) {
			terms(term);
		}
	}

	private void terms(Term<?> term) {
		if (term instanceof TermAngle) {
			eval.getStdOut().println("    Angle: " + term.getValue());
		} else if (term instanceof TermColor) {
			eval.getStdOut().println("    Color: " + term.getValue() +" - "+ term.getOperator());
		} else if (term instanceof TermExpression) {
			eval.getStdOut().println("    Expression: " + term.getValue());
		} else if (term instanceof TermFrequency) {
			eval.getStdOut().println("    Frequency: " + term.getValue());
		} else if (term instanceof TermFunction) {
			eval.getStdOut().println("    Function: " + term.getValue());
		} else if (term instanceof TermIdent) {
			eval.getStdOut().println("    Ident: " + term.getValue());
		} else if (term instanceof TermInteger) {
			eval.getStdOut().println("    Integer: " + term.getValue());
		} else if (term instanceof TermLength) {
			eval.getStdOut().println("    Length: " + term.getValue());
		} else if (term instanceof TermLengthOrPercent) {
			TermLengthOrPercent test = (TermLengthOrPercent) term;
			eval.getStdOut().println("    Length or Percent: " + term.getValue() + " - Percent? "+test.isPercentage());
		} else if (term instanceof TermList) {
			eval.getStdOut().println("    List: " + term.getValue());
		} else if (term instanceof TermNumber) {
			eval.getStdOut().println("    Number: " + term.getValue());
//		} else if (term instanceof TermNumeric) {
//			eval.getStdOut().println("    Numeric: " + term.getValue());
		} else if (term instanceof TermPair) {
			eval.getStdOut().println("    Pair: " + term.getValue());
		} else if (term instanceof TermPercent) {
			eval.getStdOut().println("    Percent: " + term.getValue());
		} else if (term instanceof TermResolution) {
			eval.getStdOut().println("    Resolution: " + term.getValue());
		} else if (term instanceof TermString) {
			eval.getStdOut().println("    String: " + term.getValue());
		} else if (term instanceof TermTime) {
			eval.getStdOut().println("    Time: " + term.getValue());
		} else if (term instanceof TermURI) {
			eval.getStdOut().println("    URI: " + term.getValue());
		}
	}
	
	private void selectors(CombinedSelector[] combinedSelectors) {
		for (CombinedSelector s : combinedSelectors) {
			//eval.getStdOut().println(s);
			realSelectors(s);
		}
	}
	
	// IVALUE CONVERSION METHODS!
	
	// @TODO HOW TO ADD THE OPTIONAL ATRIBUTESELECTORS AND PSEUDOCLASSES?!
	private IValue elementClass(Selector.ElementClass node) {
		IValue className = values.string(node.getClassName());
		return constructTypeNode("class", className, null);
	}
	
	private IValue elementId(Selector.ElementID node) {
		IValue idName = values.string(node.getID());
		return constructTypeNode("id", idName, null);
	}
	
	private IValue domElement(Selector.ElementDOM node) {
		IValue elementName = values.string(node.getElement().getTagName());
		return constructTypeNode("domElement", elementName, null);
	}
	
	private IValue combinator(Selector.Combinator node) {
		IValue combinator = values.string(node.value());
		return constructTypeNode("combinator", combinator);
	}
	
	private IValue combinatedSelector(CombinedSelector node) {
		
		IValueList selectors = new IValueList(values);
		for (Iterator it = node.iterator(); it.hasNext();) {
			Selector s = (Selector) it.next();
			for (Selector.SelectorPart sp : s) {
				
				IValue selectorPart;
				
				if (sp instanceof ElementClass) {
					selectorPart = elementClass((ElementClass) sp);
				} else if (sp instanceof ElementID) {
					selectorPart = elementId((ElementID) sp);
				} else if (sp instanceof ElementDOM) {
					selectorPart = domElement((ElementDOM) sp);
				} else if (sp instanceof ElementAttribute) {
					selectorPart = attributeselector((ElementAttribute) sp);
				} else if (sp instanceof ElementName) {
					System.out.println(((ElementName) sp).getName());
				} else {
					new AssertionError("CombinatedSelector error");
				}
			}
		}
		 
		return selectors.asList();
	}
	
	private IValue attributeselector(Selector.SelectorPart node) {
		// A visitor should be so easy
		IValue attribute = values.string(((ElementAttribute) node).getAttribute());
		IValue operator = values.string(((ElementAttribute) node).getOperator().toString());
		// Same for this one...
		IValue value = values.string(((ElementAttribute) node).getValue());
		
		IValue attributeSelectors = values.string(node.toString());
		return constructTypeNode("attributeSelectors", attribute, operator, value);
	}
	
	private IValue pseudoClass(Selector.SelectorPart node) {
		IValue psuedoClasses = values.string(node.toString());
		return constructTypeNode("psuedoClasses", psuedoClasses);
	}
	
	private IValue angle(TermAngle node) {
		IValue angle = values.real(node.getValue().doubleValue());
		IValue unit = values.string(node.getUnit().toString());
		return constructTypeNode("angle", angle, unit);
	}
	
	private IValue color(TermColor node) {
		String hex = "#"+Integer.toHexString(node.getValue().getRGB()).substring(2);
		IValue color = values.string(node.getValue().toString());
		return constructTypeNode("color", color);
	}
	
	//@TODO IMPROVE
	private IValue expression(TermExpression node) {
		IValue expression = values.string(node.getValue().toString());
		return constructTypeNode("expression", expression);
	}

	private IValue frequency(TermFrequency node) {
		IValue freq = values.string(node.getValue().toString());
		IValue unit = values.string(node.getUnit().toString());
		return constructTypeNode("frequency", freq, unit);
	}
	
	//@TODO IMPROVE
	private IValue function(TermFunction node) {
		IValue functionName = values.string(node.getFunctionName());
		IValue expression = values.string(node.getValue().toString());
		return constructTypeNode("function", functionName, expression);
	}
	
	private IValue ident(TermIdent node) {
		IValue ident = values.string(node.getValue().toString());
		return constructTypeNode("ident", ident);
	}
	
	private IValue integer(TermInteger node) {
		IValue integer = values.string(node.getValue().toString());
		return constructTypeNode("integer", integer);
	}
	
	private IValue length(TermLength node) {
		IValue length = values.string(node.getValue().toString());
		IValue unit = values.string(node.getUnit().toString());
		return constructTypeNode("length", length, unit);
	}
	
	//@TODO IMPROVE
	private IValue list(TermList node) {
		IValue list = values.string(node.getValue().toString());
		return constructTypeNode("list", list);
	}
	
	private IValue number(TermNumber node) {
		IValue number = values.string(node.getValue().toString());
		return constructTypeNode("number", number);
	}
	
//	private void numeric(TermNumeric node) {
//		IValue numeric = values.string(node.getValue().toString());
//		return constructTypeNode("numeric", numeric);
//	}
	
	//@TODO IMPROVE
	private IValue pair(TermPair node) {
		IValue pair = values.string(node.getValue().toString());
		return constructTypeNode("pair", pair);
	}
	
	private IValue percent(TermPercent node) {
		IValue percent = values.string(node.getValue().toString());
		return constructTypeNode("percent", percent);
	}
	
	private IValue resolution(TermResolution node) {
		IValue resolution = values.string(node.getValue().toString());
		IValue unit = values.string(node.getUnit().toString());
		return constructTypeNode("resolution", resolution, unit);
	}
	
	private IValue string(TermString node) {
		IValue string = values.string(node.getValue().toString());
		return constructTypeNode("string", string);
	}
	
	private IValue time(TermTime node) {
		IValue time = values.string(node.getValue().toString());
		IValue unit = values.string(node.getUnit().toString());
		return constructTypeNode("time", time, unit);
	}
	
	private IValue uri(TermURI node) {
		IValue uri = values.string(node.getValue().toString());
		return constructTypeNode("uri", uri);
	}
	
}
