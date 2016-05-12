package org.rascalmpl.library.lang.css.m3.internal.m3;

import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.value.ISourceLocation;
import org.rascalmpl.value.type.TypeStore;

import cz.vutbr.web.css.CSSComment;
import cz.vutbr.web.css.CSSNodeVisitor;
import cz.vutbr.web.css.CombinedSelector;
import cz.vutbr.web.css.Declaration;
import cz.vutbr.web.css.MediaExpression;
import cz.vutbr.web.css.MediaQuery;
import cz.vutbr.web.css.MediaSpec;
import cz.vutbr.web.css.Rule;
import cz.vutbr.web.css.RuleBlock;
import cz.vutbr.web.css.RuleCharset;
import cz.vutbr.web.css.RuleFontFace;
import cz.vutbr.web.css.RuleImport;
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
import cz.vutbr.web.css.TermCalc;
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

public class SourceConverter extends M3Converter implements CSSNodeVisitor {

	private List<String> fontFaces; 
	List<ISourceLocation> bindingLocations;
	ISourceLocation commentTarget;

	public SourceConverter(TypeStore typeStore, Map<String, ISourceLocation> cache, ISourceLocation loc, IEvaluatorContext eval) {
		super(typeStore, cache, loc, eval);
		
		bindingLocations = new ArrayList<>();
		this.fontFaces = new ArrayList<>();
	}

	public void convert(StyleSheet rules) {	
		this.stylesheet = rules;
		rules.accept(this);
	}

	@Override
	public Void visit(Declaration node) {
		//eval.getStdOut().println("Declaration");
		//eval.getStdOut().println("\t" + node.getProperty());
		
		//makeBinding("css+declaration", null, node.getProperty());
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ownValue = nodeLocation;
		
		ISourceLocation bindedLocation = makeBinding("css+declaration", null, node.getProperty());
		insert(containment, getParent(), bindedLocation);
		insert(declarations, bindedLocation, nodeLocation);
		
		scopeManager.push(bindedLocation);
		
		commentTarget = bindedLocation;
		if (node.getComment() != null) {
			node.getComment().accept(this);
		}

		if (node.isImportant()) {
			String modifier = "important";
			insert(modifiers, nodeLocation, constructModifierNode(modifier));
		}

		for (Iterator<Term<?>> it = node.iterator(); it.hasNext();) {
			Term<?> t = it.next();
			t.accept(this);
		}
		
		scopeManager.pop();

		return null;
	}

	@Override
	public Void visit(CombinedSelector node) {
		//eval.getStdOut().println("CombinedSelector");
		
		//makeBinding("css+selector", null, node.toString());
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ownValue = nodeLocation;
		
		ISourceLocation bindedLocation = makeBinding("css+selector", null, node.toString());
		insert(containment, getParent(), bindedLocation);
		insert(declarations, bindedLocation, nodeLocation);
		
		scopeManager.push(bindedLocation);

		for (Iterator<Selector> it = node.iterator(); it.hasNext();) {
			Selector s = it.next();
			s.accept(this);
		}
		
		scopeManager.pop();
		
		return null;
	}

	@Override
	public Void visit(MediaExpression node) {
		//eval.getStdOut().println("MediaExpression");
		//eval.getStdOut().println(node.getFeature());

		for (Iterator<Term<?>> it = node.iterator(); it.hasNext();) {
			Term<?> t = it.next();
			t.accept(this);
		}

		return null;
	}

	@Override
	public Void visit(MediaQuery node) {
		//eval.getStdOut().println("MediaQuery");
		//eval.getStdOut().println(node.getType());

		for (Iterator<MediaExpression> it = node.iterator(); it.hasNext();) {
			MediaExpression m = it.next();
			m.accept(this);
		}

		return null;
	}

	/**
	 * Isn't this handled already? Check it out!
	 */
	@Override
	public Void visit(MediaSpec node) {
		//eval.getStdOut().println("MediaSpec");
		return null;
	}

	/**
	 * Wtf is this?! Never called so far.
	 */
	@Override
	public Void visit(RuleArrayList node) {
		//eval.getStdOut().println("RuleArrayList");

		for (Iterator<RuleBlock<?>> it = node.iterator(); it.hasNext();) {
			RuleBlock<?> r = it.next();
			r.accept(this);
		}

		return null;
	}

	@Override
	public Void visit(RuleFontFace node) {
		//eval.getStdOut().println("RuleFontFace");		
		
		String fontTitle = "";
		
		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration d = it.next();

			if (d.getProperty().equals("font-family")) {
				fontTitle = d.asList().toString();
				fontTitle = fontTitle.substring(1, fontTitle.length()-1);
				break;
			}
		}
		
		//makeBinding("css+fontfacerule", null, fontTitle);
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ownValue = nodeLocation;
		
		ISourceLocation bindedLocation = makeBinding("css+fontfacerule", null, fontTitle);
		insert(containment, getParent(), bindedLocation);
		insert(declarations, bindedLocation, nodeLocation);
		
		commentTarget = bindedLocation;
		if (node.getComment() != null) {
			node.getComment().accept(this);
		}
		
		scopeManager.push(bindedLocation);

		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration d = it.next();
			d.accept(this);
		}
		
		if(!fontTitle.equals("")) {
			fontFaces.add(fontTitle);
		}
		
		scopeManager.pop();

		return null;
	}

	/**
	 * No clue when this is used.
	 */
	@Override
	public Void visit(RuleMargin node) {
		//eval.getStdOut().println("RuleMargin");
		
		//makeBinding("css+marginrule", null, "RULEMARGIN");
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ownValue = nodeLocation;

		ISourceLocation bindedLocation = makeBinding("css+marginrule", null, node.getMarginArea().toString());
		insert(containment, getParent(), bindedLocation);
		insert(declarations, bindedLocation, nodeLocation);
		
		commentTarget = bindedLocation;
		if (node.getComment() != null) {
			node.getComment().accept(this);
		}
		
		scopeManager.push(bindedLocation);

		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration d = it.next();
			d.accept(this);
		}
		
		scopeManager.pop();

		return null;
	}

	@Override
	public Void visit(RuleMedia node) {
		//eval.getStdOut().println("RuleMedia");
		
		//makeBinding("css+mediarule", null, "RULEMEDIA");
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ownValue = nodeLocation;
		
		ISourceLocation bindedLocation = makeBinding("css+mediarule", null, node.getMediaQueries().toString());
		insert(containment, getParent(), bindedLocation);
		insert(declarations, bindedLocation, nodeLocation);
		
		commentTarget = bindedLocation;
		if (node.getComment() != null) {
			node.getComment().accept(this);
		}
		
		scopeManager.push(bindedLocation);

		for (Iterator<MediaQuery> it = node.getMediaQueries().iterator(); it.hasNext();) {
			MediaQuery m = it.next();
			m.accept(this);
		}

		for (Iterator<RuleSet> it = node.iterator(); it.hasNext();) {
			RuleSet r = it.next();
			r.accept(this);
		}

		scopeManager.pop();

		return null;
	}

	@Override
	public Void visit(RulePage node) {
		//eval.getStdOut().println("RulePage");
		
		//makeBinding("css+pagerule", null, "RULEPAGE");
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ownValue = nodeLocation;
		
		ISourceLocation bindedLocation = makeBinding("css+pagerule", null, node.getName());
		insert(containment, getParent(), bindedLocation);
		insert(declarations, bindedLocation, nodeLocation);
		
		commentTarget = bindedLocation;
		if (node.getComment() != null) {
			node.getComment().accept(this);
		}
		
		scopeManager.push(bindedLocation);

		for (Iterator<Rule<?>> it = node.iterator(); it.hasNext();) {
			Rule<?> r = it.next();
			r.accept(this);
		}
		
		scopeManager.pop();

		return null;
	}

	@Override
	public Void visit(RuleSet node) {
		//eval.getStdOut().println("RuleSet");
		
		String selectors = "";
		
		for (CombinedSelector cs : node.getSelectors()) {			
			selectors += cs.toString()+",";
		}
		
		selectors = selectors.substring(0, selectors.length()-1);
		
		//makeBinding("css+ruleset", null, selectors);
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ownValue = nodeLocation;
		
		ISourceLocation bindedLocation = makeBinding("css+ruleset", null, selectors);
		insert(containment, getParent(), bindedLocation);
		insert(declarations, bindedLocation, nodeLocation);
		
		commentTarget = bindedLocation;
		if (node.getComment() != null) {
			node.getComment().accept(this);
		}
		
		scopeManager.push(bindedLocation);

		for (CombinedSelector cs : node.getSelectors()) {
			cs.accept(this);
		}

		for (Declaration cs : node) {
			cs.accept(this);
		}
		
		scopeManager.pop();

		return null;
	}

	@Override
	public Void visit(RuleViewport node) {
		//eval.getStdOut().println("RuleViewport");
		
		String declarationsKey = "";
		
		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration d = it.next();
			declarationsKey += d.toString();
		}
		
		declarationsKey = declarationsKey.substring(0, -1);
		
		//makeBinding("css+viewportrule", null, declarations);
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ownValue = nodeLocation;
		
		ISourceLocation bindedLocation = makeBinding("css+viewportrule", null, declarationsKey);
		
		commentTarget = bindedLocation;
		if (node.getComment() != null) {
			node.getComment().accept(this);
		}
		
		insert(containment, getParent(), bindedLocation);
		insert(declarations, bindedLocation, nodeLocation);
		
		scopeManager.push(bindedLocation);

		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration d = it.next();
			d.accept(this);
		}
		
		scopeManager.pop();

		return null;
	}

	@Override
	public Void visit(Selector node) {
		//eval.getStdOut().println("Selector");
		//eval.getStdOut().println("\t" + node.getCombinator());

		for (Iterator<SelectorPart> it = node.iterator(); it.hasNext();) {
			SelectorPart m = it.next();
			m.accept(this);
		}

		return null;
	}

	@Override
	public Void visit(StyleSheet node) {
		//eval.getStdOut().println("StyleSheet");
		
		// @TODO Find a way to get the file name here.
		//makeBinding("css+stylesheet", null, "style1.css");
		ownValue = loc;
		
		ISourceLocation bindedLocation = makeBinding("css+stylesheet", null, loc.getPath());
		
		scopeManager.push(bindedLocation);

		commentTarget = bindedLocation;
		if (node.getComment() != null) {
			node.getComment().accept(this);
		}

		for (Iterator<RuleBlock<?>> it = node.iterator(); it.hasNext();) {
			RuleBlock<?> r = it.next();
			r.accept(this);
		}
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		insert(declarations, bindedLocation, nodeLocation);
		
		insert(messages, values.constructor(DATATYPE_RASCAL_MESSAGE_ERROR_NODE_TYPE, values.string("HOMOOO"), nodeLocation));
		
		scopeManager.pop();

		return null;
	}

	@Override
	public Void visit(TermAngle node) {
		//eval.getStdOut().println("TermAngle");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Void visit(TermColor node) {
		//eval.getStdOut().println("TermColor");
		//eval.getStdOut().println("\t" + node.getValue());
		return null;
	}

	@Override
	public Void visit(TermExpression node) {
		//eval.getStdOut().println("TermExpression");
		//eval.getStdOut().println("\t" + node.getValue());
		return null;
	}

	/**
	 * This one can go? Since all its children are covered?
	 */
	@Override
	public Void visit(TermFloatValue node) {
		//eval.getStdOut().println("TermFloatValue");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Void visit(TermFrequency node) {
		//eval.getStdOut().println("TermFrequency");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Void visit(TermFunction node) {
		//eval.getStdOut().println("TermFunction");
		//eval.getStdOut().println(node.getFunctionName());

		for (Iterator<Term<?>> it = node.iterator(); it.hasNext();) {
			Term<?> t = it.next();
			t.accept(this);
		}

		return null;
	}

	@Override
	public Void visit(TermIdent node) {
		//eval.getStdOut().println("TermIdent");
		//eval.getStdOut().println("\t" + node.getValue());
		
		if (checkIfFontFace(node.getValue())) {
			//eval.getStdOut().println("RTYUIOP");
		}
		
		return null;
	}
	
	private boolean checkIfFontFace(String cur) {
		for (String element : fontFaces) {
			if(element.equals(cur)) {
				return true;
			}
		}
		return false;
	}

	@Override
	public Void visit(TermInteger node) {
		//eval.getStdOut().println("TermInteger");
		// For some strange reason termInteger contains floats...
		//eval.getStdOut().println("\t" + node.getValue().intValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Void visit(TermLength node) {
		//eval.getStdOut().println("TermLength");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	/**
	 * This one can go?
	 */
	@Override
	public Void visit(TermList node) {
		//eval.getStdOut().println("TermList");
		return null;
	}

	@Override
	public Void visit(TermNumber node) {
		//eval.getStdOut().println("TermNumber");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Void visit(TermPercent node) {
		//eval.getStdOut().println("TermPercent");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Void visit(TermResolution node) {
		//eval.getStdOut().println("TermResolution");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Void visit(TermString node) {
		//eval.getStdOut().println("TermString");
		//eval.getStdOut().println("\t" + node.getValue());
		return null;
	}

	@Override
	public Void visit(TermTime node) {
		//eval.getStdOut().println("TermTime");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		return null;
	}

	@Override
	public Void visit(TermURI node) {
		//eval.getStdOut().println("TermURI");
		//eval.getStdOut().println("\t" + node.getValue());
		return null;
	}

	@Override
	public Void visit(ElementAttribute node) {
		//eval.getStdOut().println("ElementAttribute");
		//eval.getStdOut().println("\t" + node.getAttribute() + " " + node.getOperator() + " " + node.getValue());
		return null;
	}

	@Override
	public Void visit(ElementClass node) {
		//eval.getStdOut().println("ElementClass");
		//eval.getStdOut().println("\t" + node.getClassName());
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ownValue = nodeLocation;
		
		ISourceLocation bindedLocation = makeBinding("css+class", null, node.getClassName().substring(1, node.getClassName().length()));
		
		insert(names, values.string(node.getClassName().substring(1, node.getClassName().length())), bindedLocation);
		insert(declarations, bindedLocation, nodeLocation);

		return null;
	}

	/**
	 * This one can go I guess? ElementName really handles stuff like "div" and
	 * "span". Not this one. Not even visited so far.
	 */
	@Override
	public Void visit(ElementDOM node) {
		//eval.getStdOut().println("ElementDOM");
		//eval.getStdOut().println("\t" + node.getElement());
		return null;
	}

	@Override
	public Void visit(ElementID node) {
		//eval.getStdOut().println("ElementID");
		//eval.getStdOut().println("\t" + node.getID());
		
		//makeBinding("css+id", null, node.getID());
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ownValue = nodeLocation;
		
		ISourceLocation bindedLocation = makeBinding("css+id", null, node.getID().substring(1, node.getID().length()));
		
		insert(names, values.string(node.getID().substring(1, node.getID().length())), bindedLocation);
		insert(declarations, bindedLocation, nodeLocation);
		
		return null;
	}

	@Override
	public Void visit(ElementName node) {
		//eval.getStdOut().println("ElementName");
		//eval.getStdOut().println("\t" + node.getName());
		return null;
	}

	@Override
	public Void visit(PseudoPage node) {
		//eval.getStdOut().println("PseudoPage");
		//eval.getStdOut().println("\t" + node.getValue());
		return null;
	}
	
	@Override
	public Object visit(RuleImport node) {
		//eval.getStdOut().println("RuleImport");
		
		//makeBinding("css+importrule", null, node.getURI());
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ownValue = nodeLocation;
		
		ISourceLocation bindedLocation = makeBinding("css+importrule", null, node.getURI());
		
		commentTarget = bindedLocation;
		if (node.getComment() != null) {
			node.getComment().accept(this);
		}
		
		insert(containment, getParent(), bindedLocation);
		insert(declarations, bindedLocation, nodeLocation);

		return null;
	}
	
	@Override
	public Object visit(CSSComment node) {
		//eval.getStdOut().println("CSSComment");
		
		//eval.getStdOut().println(node.getText());
		
		//eval.getStdOut().println("Parent: "+getParent().getPath());
		
		//makeBinding("css+comment", null, node.getText());
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ownValue = nodeLocation;
		
		//ISourceLocation bindedLocation = makeBinding("css+comment", null, node.getText());
		
		insert(documentation, commentTarget, nodeLocation);
		//insert(containment, commentTarget, nodeLocation);
		//insert(declarations, bindedLocation, nodeLocation);

		return null;
	}
	
	private ISourceLocation checkBinding(String scheme, String authority, String path, int i) {
		ISourceLocation loc;
		try {
			if (i==0) {
				loc = values.sourceLocation(scheme, authority, path);
			} else {
				loc = values.sourceLocation(scheme, authority, path+"("+i+")");
			}
			if (bindingLocations.contains(loc)) {
				int a = i+1;
				return checkBinding(scheme, authority, path, a);
			} else {
				return loc;
			}
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return null;
	}
	
	protected ISourceLocation makeBinding(String scheme, String authority, String path) {
		ISourceLocation loc = checkBinding(scheme, authority, path, 0);
		bindingLocations.add(loc);
		return loc;
	}

	@Override
	public Object visit(RuleCharset node) {
		//eval.getStdOut().println("RuleCharset");

		//makeBinding("css+importrule", null, node.getURI());
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ownValue = nodeLocation;
		
		ISourceLocation bindedLocation = makeBinding("css+charsetrule", null, node.getCharset());
		
		commentTarget = bindedLocation;
		if (node.getComment() != null) {
			node.getComment().accept(this);
		}
		
		insert(containment, getParent(), bindedLocation);
		insert(declarations, bindedLocation, nodeLocation);

		return null;
	}

	@Override
	public Object visit(TermCalc node) {
		//eval.getStdOut().println("TermCalc");
		//eval.getStdOut().println("\t" + node.getValue());
		return null;
	}
	
}
