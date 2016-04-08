package org.rascalmpl.library.lang.css.m3.internal;

import java.util.HashMap;
import java.util.Iterator;

import org.rascalmpl.interpreter.IEvaluatorContext;
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
		super(store, new HashMap<>());
		this.eval = eval;

		rules.accept(this);
	}

	@Override
	public Object visit(Declaration node) {
		eval.getStdOut().println("Declaration");

		eval.getStdOut().println("\t" + node.getProperty());

		for (Iterator<Term<?>> it = node.iterator(); it.hasNext();) {
			Term<?> t = it.next();
			t.accept(this);
		}

		return null;
	}

	@Override
	public Object visit(CombinedSelector node) {
		eval.getStdOut().println("CombinedSelector");

		for (Iterator<Selector> it = node.iterator(); it.hasNext();) {
			Selector s = it.next();
			s.accept(this);
		}

		return null;
	}

	@Override
	public Object visit(MediaExpression node) {
		eval.getStdOut().println("MediaExpression");
		eval.getStdOut().println(node.getFeature());
		for (Iterator<Term<?>> it = node.iterator(); it.hasNext();) {
			Term<?> t = it.next();
			t.accept(this);
		}

		return null;
	}

	@Override
	public Object visit(MediaQuery node) {
		eval.getStdOut().println("MediaQuery");

		eval.getStdOut().println(node.getType());

		for (Iterator<MediaExpression> it = node.iterator(); it.hasNext();) {
			MediaExpression m = it.next();
			m.accept(this);
		}

		return null;
	}

	@Override
	public Object visit(MediaSpec node) {
		eval.getStdOut().println("MediaSpec");

		return null;
	}

	@Override
	public Object visit(RuleArrayList node) {
		eval.getStdOut().println("RuleArrayList");

		for (Iterator<RuleBlock<?>> it = node.iterator(); it.hasNext();) {
			RuleBlock<?> r = it.next();
			r.accept(this);
		}

		return null;
	}

	@Override
	public Object visit(RuleFontFace node) {
		eval.getStdOut().println("RuleFontFace");

		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration d = it.next();
			d.accept(this);
		}

		return null;
	}

	@Override
	public Object visit(RuleMargin node) {
		eval.getStdOut().println("RuleMargin");

		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration d = it.next();
			d.accept(this);
		}

		return null;
	}

	@Override
	public Object visit(RuleMedia node) {
		eval.getStdOut().println("RuleMedia");

		for (Iterator<MediaQuery> it = node.getMediaQueries().iterator(); it.hasNext();) {
			MediaQuery m = it.next();
			m.accept(this);
		}

		for (Iterator<RuleSet> it = node.iterator(); it.hasNext();) {
			RuleSet r = it.next();
			r.accept(this);
		}

		return null;
	}

	@Override
	public Object visit(RulePage node) {
		eval.getStdOut().println("RulePage");

		for (Iterator<Rule<?>> it = node.iterator(); it.hasNext();) {
			Rule<?> r = it.next();
			r.accept(this);
		}

		return null;
	}

	@Override
	public Object visit(RuleSet node) {
		eval.getStdOut().println("RuleSet");

		for (CombinedSelector cs : node.getSelectors()) {
			cs.accept(this);
		}

		for (Declaration cs : node) {
			cs.accept(this);
		}

		eval.getStdOut().println("");

		return null;
	}

	@Override
	public Object visit(RuleViewport node) {
		eval.getStdOut().println("RuleViewport");

		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration m = it.next();
			m.accept(this);
		}

		return null;
	}

	@Override
	public Object visit(Selector node) {
		eval.getStdOut().println("Selector");

		if (node.getCombinator() != null) {
			eval.getStdOut().println(node.getCombinator());
		}

		for (Iterator<SelectorPart> it = node.iterator(); it.hasNext();) {
			SelectorPart m = it.next();
			m.accept(this);
		}

		return null;
	}

	@Override
	public Object visit(StyleSheet node) {
		eval.getStdOut().println("StyleSheet");

		for (Iterator<RuleBlock<?>> it = node.iterator(); it.hasNext();) {
			RuleBlock<?> r = it.next();
			r.accept(this);
		}

		return null;
	}

	// @Override
	// public Object visit(Term node) {
	// eval.getStdOut().println("Term");
	//
	// return null;
	// }

	@Override
	public Object visit(TermAngle node) {
		eval.getStdOut().println("TermAngle");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Object visit(TermColor node) {
		eval.getStdOut().println("TermColor");
		eval.getStdOut().println("\t" + node.getValue());
		return null;
	}

	@Override
	public Object visit(TermExpression node) {
		eval.getStdOut().println("TermExpression");
		eval.getStdOut().println("\t" + node.getValue());
		return null;
	}

	@Override
	public Object visit(TermFloatValue node) {
		eval.getStdOut().println("TermFloatValue");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Object visit(TermFrequency node) {
		eval.getStdOut().println("TermFrequency");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Object visit(TermFunction node) {
		eval.getStdOut().println("TermFunction");
		eval.getStdOut().println(node.getFunctionName());
		for (Iterator<Term<?>> it = node.iterator(); it.hasNext();) {
			Term<?> t = it.next();
			t.accept(this);
		}

		return null;
	}

	@Override
	public Object visit(TermIdent node) {
		eval.getStdOut().println("TermIdent");
		eval.getStdOut().println("\t" + node.getValue());
		return null;
	}

	@Override
	public Object visit(TermInteger node) {
		eval.getStdOut().println("TermInteger");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Object visit(TermList node) {
		eval.getStdOut().println("TermList");
		return null;
	}

	@Override
	public Object visit(TermNumber node) {
		eval.getStdOut().println("TermNumber");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	// @Override
	// public Object visit(TermPair node) {
	// eval.getStdOut().println("TermPair");
	// return null;
	// }

	@Override
	public Object visit(TermPercent node) {
		eval.getStdOut().println("TermPercent");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Object visit(TermResolution node) {
		eval.getStdOut().println("TermResolution");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Object visit(TermString node) {
		eval.getStdOut().println("TermString");
		eval.getStdOut().println("\t" + node.getValue());
		return null;
	}

	@Override
	public Object visit(TermTime node) {
		eval.getStdOut().println("TermTime");
		eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Object visit(TermURI node) {
		eval.getStdOut().println("TermURI");
		eval.getStdOut().println("\t" + node.getValue());
		return null;
	}

	// @Override
	// public Object visit(SelectorPart node) {
	// eval.getStdOut().println("SelectorPart");
	//
	// return null;
	// }

	@Override
	public Object visit(ElementAttribute node) {
		eval.getStdOut().println("ElementAttribute");
		eval.getStdOut().println("\t" + node.getAttribute() + " " + node.getOperator() + " " + node.getValue());
		return null;
	}

	@Override
	public Object visit(ElementClass node) {
		eval.getStdOut().println("ElementClass");
		eval.getStdOut().println("\t" + node.getClassName());
		return null;
	}

	@Override
	public Object visit(ElementDOM node) {
		eval.getStdOut().println("ElementDOM");
		eval.getStdOut().println("\t" + node.getElement());
		return null;
	}

	@Override
	public Object visit(ElementID node) {
		eval.getStdOut().println("ElementID");
		eval.getStdOut().println("\t" + node.getID());
		return null;
	}

	@Override
	public Object visit(ElementName node) {
		eval.getStdOut().println("ElementName");
		eval.getStdOut().println("\t" + node.getName());
		return null;
	}

	@Override
	public Object visit(PseudoPage node) {
		eval.getStdOut().println("PseudoPage");
		eval.getStdOut().println("\t" + node.getValue());
		return null;
	}

}
