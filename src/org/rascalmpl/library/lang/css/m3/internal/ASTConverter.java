package org.rascalmpl.library.lang.css.m3.internal;

import java.util.Collection;

import org.rascalmpl.interpreter.IEvaluatorContext;

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
import cz.vutbr.web.css.TermNumeric;
import cz.vutbr.web.css.TermPair;
import cz.vutbr.web.css.TermPercent;
import cz.vutbr.web.css.TermResolution;
import cz.vutbr.web.css.TermString;
import cz.vutbr.web.css.TermTime;
import cz.vutbr.web.css.TermURI;

public class ASTConverter {
	
	private IEvaluatorContext eval;
	
	public ASTConverter(Collection<RuleBlock<?>> rules, IEvaluatorContext eval) {
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
				eval.getStdOut().println("EXOTIC STUFF");
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
			eval.getStdOut().println(decl.getSource());
			eval.getStdOut().println("  Property: " + decl.getProperty());
			eval.getStdOut().println("  Values: ");
			declarations(decl);
		}
	}

	private void ruleMedia(RuleBlock<?> ruleBlock) {
		eval.getStdOut().println("This is a ruleMedia");
		eval.getStdOut().println("");
		RuleMedia media = (RuleMedia) ruleBlock;
		eval.getStdOut().println("Media: " + media.getMediaQueries());
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
		//eval.getStdOut().println("MaginAre: " + media.getMarginArea());
		for (Declaration set : media) {
			declarations(set);
		}
	}
	
	private void realSelectors(CombinedSelector s2) {
		for (Selector s : s2) {
			for (Selector.SelectorPart sp : s) {
				eval.getStdOut().println(sp.toString());
				eval.getStdOut().println("REAL SELECTORS: "+s.getClassName()+" - "+s.getElementName()+" - "+s.getIDName()+" - "+s.getCombinator()+ " - "+s.getPseudoElement());
			}
		}
	}
	
	private void mediaExpression(MediaExpression exp) {
		eval.getStdOut().println("mediaExpression: "+exp.getFeature());
		
	}
	
	private void mediaQuery(MediaQuery q) {
		eval.getStdOut().println("mediaQuery: "+q.getType());
		
	}

	private void rules(Rule<?> rules) {
		eval.getStdOut().println("Rules!");
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
		//eval.getStdOut().println("Declaration source: "+decl.getSource());
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
		} else if (term instanceof TermNumeric) {
			eval.getStdOut().println("    Numeric: " + term.getValue());
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
			eval.getStdOut().println(s);
			realSelectors(s);
		}
	}
	
}
