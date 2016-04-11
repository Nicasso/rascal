package org.rascalmpl.library.lang.css.m3.internal;

import java.util.HashMap;
import java.util.Iterator;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.type.TypeStore;

import cz.vutbr.web.CSSNodeVisitor;
import cz.vutbr.web.css.CombinedSelector;
import cz.vutbr.web.css.Declaration;
import cz.vutbr.web.css.MediaExpression;
import cz.vutbr.web.css.MediaQuery;
import cz.vutbr.web.css.MediaSpec;
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
import cz.vutbr.web.css.Selector.PseudoPage;
import cz.vutbr.web.css.Selector.SelectorPart;
import cz.vutbr.web.css.StyleSheet;
import cz.vutbr.web.css.Term;
import cz.vutbr.web.css.TermAngle;
import cz.vutbr.web.css.TermColor;
import cz.vutbr.web.css.TermExpression;
import cz.vutbr.web.css.TermFloatValue;
import cz.vutbr.web.css.TermFrequency;
import cz.vutbr.web.css.TermFunction;
import cz.vutbr.web.css.TermIdent;
import cz.vutbr.web.css.TermInteger;
import cz.vutbr.web.css.TermLength;
import cz.vutbr.web.css.TermList;
import cz.vutbr.web.css.TermNumber;
import cz.vutbr.web.css.TermPercent;
import cz.vutbr.web.css.TermResolution;
import cz.vutbr.web.css.TermString;
import cz.vutbr.web.css.TermTime;
import cz.vutbr.web.css.TermURI;
import cz.vutbr.web.csskit.RuleArrayList;

public class ASTConverter extends CSSToRascalConverter implements CSSNodeVisitor {

	private IEvaluatorContext eval;

	public ASTConverter(StyleSheet rules, TypeStore store, IEvaluatorContext eval) {
		super(store, new HashMap<>(), eval);
		this.eval = eval;

		rules.accept(this);
	}

	@Override
	public IValue visit(Declaration node) {
		eval.getStdOut().println("Declaration");
		eval.getStdOut().println("\t" + node.getProperty());
		
		IValue property = values.string(node.getProperty());

		IValueList declarationValues = new IValueList(values);
		for (Iterator<Term<?>> it = node.iterator(); it.hasNext();) {
			Term<?> t = it.next();
			IValue temp = (IValue) t.accept(this);
			declarationValues.add(temp);
		}

		return constructDeclarationNode("declaration", property, declarationValues.asList());
	}

	@Override
	public IValue visit(CombinedSelector node) {
		eval.getStdOut().println("CombinedSelector");

		IValueList selectors = new IValueList(values);
		for (Iterator<Selector> it = node.iterator(); it.hasNext();) {
			Selector s = it.next();
			IValue temp = (IValue) s.accept(this);
			selectors.add(temp);
		}
		eval.getStdOut().println("CombinedSelector selectors: "+selectors.asList());
		eval.getStdOut().println("constructTypeNode CombinedSelector");
		return constructTypeNode("combinedSelector", selectors.asList());
	}

	@Override
	public IValue visit(MediaExpression node) {
		eval.getStdOut().println("MediaExpression");
		eval.getStdOut().println(node.getFeature());
		
		IValue feature = values.string(node.getFeature());
		
		IValueList expressions = new IValueList(values);
		for (Iterator<Term<?>> it = node.iterator(); it.hasNext();) {
			Term<?> t = it.next();
			IValue temp = (IValue) t.accept(this);
			expressions.add(temp);
		}

		return constructExpressionNode("mediaExpression", feature, expressions.asList());
	}

	@Override
	public IValue visit(MediaQuery node) {
		eval.getStdOut().println("MediaQuery");
		eval.getStdOut().println(node.getType());
		
		IValue type = values.string(node.getType());

		IValueList expressions = new IValueList(values);
		for (Iterator<MediaExpression> it = node.iterator(); it.hasNext();) {
			MediaExpression m = it.next();
			IValue temp = (IValue) m.accept(this);
			expressions.add(temp);
		}

		return constructTypeNode("MediaQuery", type, expressions.asList());
	}

	/**
	 * Isn't this handled already? Check it out!
	 */
	@Override
	public IValue visit(MediaSpec node) {
		eval.getStdOut().println("MediaSpec");
		return null;
	}

	/**
	 * Wtf is this?! Never called so far.
	 */
	@Override
	public IValue visit(RuleArrayList node) {
		eval.getStdOut().println("RuleArrayList");

		for (Iterator<RuleBlock<?>> it = node.iterator(); it.hasNext();) {
			RuleBlock<?> r = it.next();
			r.accept(this);
		}

		return null;
	}

	@Override
	public IValue visit(RuleFontFace node) {
		eval.getStdOut().println("RuleFontFace");

		IValueList declarations = new IValueList(values);
		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration d = it.next();
			IValue temp = (IValue) d.accept(this);
			declarations.add(temp);
		}

		return constructStatementNode("ruleFontFace", declarations.asList());
	}

	/**
	 * No clue when this is used.
	 */
	@Override
	public IValue visit(RuleMargin node) {
		eval.getStdOut().println("RuleMargin");

		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration d = it.next();
			d.accept(this);
		}

		return null;
	}

	@Override
	public IValue visit(RuleMedia node) {
		eval.getStdOut().println("RuleMedia");

		IValueList mediaQueries = new IValueList(values);
		for (Iterator<MediaQuery> it = node.getMediaQueries().iterator(); it.hasNext();) {
			MediaQuery m = it.next();
			IValue temp = (IValue) m.accept(this);
			mediaQueries.add(temp);
		}

		IValueList ruleSets = new IValueList(values);
		for (Iterator<RuleSet> it = node.iterator(); it.hasNext();) {
			RuleSet r = it.next();
			IValue temp = (IValue) r.accept(this);
			ruleSets.add(temp);
		}

		return constructStatementNode("ruleMedia", mediaQueries.asList(), ruleSets.asList());
	}

	@Override
	public IValue visit(RulePage node) {
		eval.getStdOut().println("RulePage");
		
		IValue pseudo = values.string(node.getPseudo());

		IValueList declarations = new IValueList(values);
		for (Iterator<Rule<?>> it = node.iterator(); it.hasNext();) {
			Rule<?> r = it.next();
			IValue temp = (IValue) r.accept(this);
			declarations.add(temp);
		}

		return constructStatementNode("rulePage", pseudo, declarations.asList());
	}

	@Override
	public IValue visit(RuleSet node) {
		eval.getStdOut().println("RuleSet");

		IValueList selectors = new IValueList(values);
		for (CombinedSelector cs : node.getSelectors()) {
			IValue temp = (IValue) cs.accept(this);
			selectors.add(temp);
		}

		IValueList declarations = new IValueList(values);
		for (Declaration cs : node) {
			IValue temp = (IValue) cs.accept(this);
			declarations.add(temp);
		}

		return constructStatementNode("ruleSet", selectors.asList(), declarations.asList());
	}

	@Override
	public IValue visit(RuleViewport node) {
		eval.getStdOut().println("RuleViewport");

		IValueList declarations = new IValueList(values);
		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration d = it.next();
			IValue temp = (IValue) d.accept(this);
			declarations.add(temp);
		}

		return constructStatementNode("ruleViewport", declarations.asList());
	}

	@Override
	public IValue visit(Selector node) {
		eval.getStdOut().println("Selector");
		eval.getStdOut().println("\t"+node.getCombinator());

		IValueList statements = new IValueList(values);
		for (Iterator<SelectorPart> it = node.iterator(); it.hasNext();) {
			SelectorPart m = it.next();
			IValue temp = (IValue) m.accept(this);
			statements.add(temp);
		}
		
		if (node.getCombinator() != null) {
			IValue combinator = values.string(node.getCombinator().toString());
			return constructExpressionNode("selector", statements.asList(), combinator);
		} else {
			return constructExpressionNode("selector", statements.asList());
		}
	}

	@Override
	public IValue visit(StyleSheet node) {
		eval.getStdOut().println("StyleSheet");

		IValueList statements = new IValueList(values);
		for (Iterator<RuleBlock<?>> it = node.iterator(); it.hasNext();) {
			RuleBlock<?> r = it.next();
			IValue temp = (IValue) r.accept(this);
			statements.add(temp);
		}

		return constructStatementNode("stylesheet", statements.asList());
	}

	@Override
	public IValue visit(TermAngle node) {
		eval.getStdOut().println("TermAngle");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue angle = values.real(node.getValue().doubleValue());
	    IValue unit = values.string(node.getUnit().toString());
	    return constructTypeNode("angle", angle, unit);
	}

	@Override
	public IValue visit(TermColor node) {
		eval.getStdOut().println("TermColor");
		eval.getStdOut().println("\t" + node.getValue());
		
		IValue red = values.integer(node.getValue().getRed());
		IValue green = values.integer(node.getValue().getGreen());
		IValue blue = values.integer(node.getValue().getBlue());
		IValue alpha = values.integer(node.getValue().getAlpha());
		return constructTypeNode("color", red, green, blue, alpha);
	}

	@Override
	public IValue visit(TermExpression node) {
		eval.getStdOut().println("TermExpression");
		eval.getStdOut().println("\t" + node.getValue());
		
		IValue expression = values.string(node.getValue().toString());
		return constructTypeNode("expression", expression);
	}

	/**
	 * This one can go? Since all its children are covered?
	 */
	@Override
	public IValue visit(TermFloatValue node) {
		eval.getStdOut().println("TermFloatValue");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public IValue visit(TermFrequency node) {
		eval.getStdOut().println("TermFrequency");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue freq = values.real(node.getValue());
		IValue unit = values.string(node.getUnit().toString());
		return constructTypeNode("frequency", freq, unit);
	}

	@Override
	public IValue visit(TermFunction node) {
		eval.getStdOut().println("TermFunction");
		eval.getStdOut().println(node.getFunctionName());

		IValue functionName = values.string(node.getFunctionName());
		
		IValueList expressions = new IValueList(values);
		for (Iterator<Term<?>> it = node.iterator(); it.hasNext();) {
			Term<?> t = it.next();
			IValue temp = (IValue) t.accept(this);
			expressions.add(temp);
		}

		return constructTypeNode("function", functionName, expressions.asList());
	}

	@Override
	public IValue visit(TermIdent node) {
		eval.getStdOut().println("TermIdent");
		eval.getStdOut().println("\t" + node.getValue());
		
		IValue ident = values.string(node.getValue().toString());
		return constructTypeNode("ident", ident);
	}

	@Override
	public IValue visit(TermInteger node) {
		eval.getStdOut().println("TermInteger");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue integer = values.integer(node.getValue().toString());
		return constructTypeNode("integer", integer);
	}
	
	@Override
	public IValue visit(TermLength node) {
		eval.getStdOut().println("TermLength");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue length = values.real(node.getValue());
		IValue unit = values.string(node.getUnit().toString());
		return constructTypeNode("length", length, unit);
	}

	/**
	 * This one can go?
	 */
	@Override
	public IValue visit(TermList node) {
		eval.getStdOut().println("TermList");
		return null;
	}

	@Override
	public IValue visit(TermNumber node) {
		eval.getStdOut().println("TermNumber");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue number = values.real(node.getValue());
		return constructTypeNode("number", number);
	}

	@Override
	public IValue visit(TermPercent node) {
		eval.getStdOut().println("TermPercent");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue percent = values.real(node.getValue());
		return constructTypeNode("percent", percent);
	}

	@Override
	public IValue visit(TermResolution node) {
		eval.getStdOut().println("TermResolution");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue resolution = values.real(node.getValue());
		IValue unit = values.string(node.getUnit().toString());
		return constructTypeNode("resolution", resolution, unit);
	}

	@Override
	public IValue visit(TermString node) {
		eval.getStdOut().println("TermString");
		eval.getStdOut().println("\t" + node.getValue());
		
		IValue string = values.string(node.getValue().toString());
		return constructTypeNode("string", string);
	}

	@Override
	public IValue visit(TermTime node) {
		eval.getStdOut().println("TermTime");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue time = values.real(node.getValue());
		IValue unit = values.string(node.getUnit().toString());
		return constructTypeNode("time", time, unit);
	}

	@Override
	public IValue visit(TermURI node) {
		eval.getStdOut().println("TermURI");
		eval.getStdOut().println("\t" + node.getValue());

		IValue uri = values.string(node.getValue().toString());
		return constructTypeNode("uri", uri);
	}

	@Override
	public IValue visit(ElementAttribute node) {
		eval.getStdOut().println("ElementAttribute");
		eval.getStdOut().println("\t" + node.getAttribute() + " " + node.getOperator() + " " + node.getValue());
		
		IValue attribute = values.string(node.getAttribute().toString());
		IValue operator = values.string(node.getOperator().toString());
		IValue value = values.string(node.getValue().toString());
		return constructTypeNode("attributeSelector", attribute, operator, value);
	}

	@Override
	public IValue visit(ElementClass node) {
		eval.getStdOut().println("ElementClass");
		eval.getStdOut().println("\t" + node.getClassName());
		
		IValue className = values.string(node.getClassName());
		return constructTypeNode("class", className);
	}

	/**
	 *  This one can go I guess? ElementName really handles stuff like "div" and "span". Not this one.
	 *  Not even visited so far.
	 */
	@Override
	public IValue visit(ElementDOM node) {
		eval.getStdOut().println("ElementDOM");
		eval.getStdOut().println("\t" + node.getElement());
		
		IValue domElement = values.string(node.getElement().getTagName());
		return constructTypeNode("domElement", domElement);
	}

	@Override
	public IValue visit(ElementID node) {
		eval.getStdOut().println("ElementID");
		eval.getStdOut().println("\t" + node.getID());
		
		IValue idName = values.string(node.getID());
		return constructTypeNode("id", idName);
	}

	@Override
	public IValue visit(ElementName node) {
		eval.getStdOut().println("ElementName");
		eval.getStdOut().println("\t" + node.getName());
		
		IValue elemName = values.string(node.getName());
		return constructTypeNode("domElement", elemName);
	}

	@Override
	public IValue visit(PseudoPage node) {
		eval.getStdOut().println("PseudoPage");
		eval.getStdOut().println("\t" + node.getValue());
		
		IValue pseudoPage = values.string(node.getValue());
		return constructTypeNode("pseudoClass", pseudoPage);
	}

}
