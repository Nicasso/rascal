package org.rascalmpl.library.lang.css.m3.internal.ast;

import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.library.lang.css.m3.internal.CSSToRascalConverter;
import org.rascalmpl.library.lang.css.m3.internal.IValueList;
import org.rascalmpl.value.IConstructor;
import org.rascalmpl.value.IList;
import org.rascalmpl.value.ISourceLocation;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.type.TypeStore;

import cz.vutbr.web.css.CSSComment;
import cz.vutbr.web.css.CSSNodeVisitor;
import cz.vutbr.web.css.CodeLocation;
import cz.vutbr.web.css.CombinedSelector;
import cz.vutbr.web.css.Declaration;
import cz.vutbr.web.css.MediaExpression;
import cz.vutbr.web.css.MediaQuery;
import cz.vutbr.web.css.MediaSpec;
import cz.vutbr.web.css.Rule;
import cz.vutbr.web.css.RuleBlock;
import cz.vutbr.web.css.RuleCharset;
import cz.vutbr.web.css.RuleCounterStyle;
import cz.vutbr.web.css.RuleFontFace;
import cz.vutbr.web.css.RuleImport;
import cz.vutbr.web.css.RuleKeyframes;
import cz.vutbr.web.css.RuleMargin;
import cz.vutbr.web.css.RuleMedia;
import cz.vutbr.web.css.RuleNameSpace;
import cz.vutbr.web.css.RulePage;
import cz.vutbr.web.css.RuleSet;
import cz.vutbr.web.css.RuleViewport;
import cz.vutbr.web.css.Selector;
import cz.vutbr.web.css.Selector.ElementAttribute;
import cz.vutbr.web.css.Selector.ElementClass;
import cz.vutbr.web.css.Selector.ElementDOM;
import cz.vutbr.web.css.Selector.ElementID;
import cz.vutbr.web.css.Selector.ElementName;
import cz.vutbr.web.css.Selector.KeyframesIdent;
import cz.vutbr.web.css.Selector.KeyframesPercentage;
import cz.vutbr.web.css.Selector.PseudoPage;
import cz.vutbr.web.css.Selector.SelectorPart;
import cz.vutbr.web.css.StyleSheet;
import cz.vutbr.web.css.Term;
import cz.vutbr.web.css.TermAngle;
import cz.vutbr.web.css.TermAudio;
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
import cz.vutbr.web.csskit.CSSError;
import cz.vutbr.web.csskit.RuleArrayList;

public class ASTConverter extends CSSToRascalConverter implements CSSNodeVisitor {

	private IEvaluatorContext eval;
	
	private IValue ast;

	public ASTConverter(StyleSheet rules, TypeStore store, ISourceLocation loc, IEvaluatorContext eval) {
		super(store, new HashMap<>(), loc, eval);
		this.eval = eval;
		
		ast = (IValue) rules.accept(this);
		ast = ((IConstructor) ast).asAnnotatable().setAnnotation("messages", getCompilationUnitMessages(rules, true));
	}
	
	protected IValue getCompilationUnitMessages(StyleSheet stylesheet, boolean insertErrors) {
		org.rascalmpl.value.type.Type args = TF.tupleType(TF.stringType(), TF.sourceLocationType());

		IValueList result = new IValueList(values);

		if (insertErrors) {
			int i;
			List<CSSError> problems = stylesheet.getCSSErrors();
			for (i = 0; i < problems.size(); i++) {
				ISourceLocation pos = createLocation(loc, problems.get(i).getLocation());
				
				org.rascalmpl.value.type.Type constr;
				constr = typeStore.lookupConstructor(this.typeStore.lookupAbstractDataType("Message"), "error", args);
				result.add(values.constructor(constr, values.string(problems.get(i).getMessage()), pos));
			}
		}
		
		return result.asList();
	}
	
	public IValue getAST() {
		return ast;
	}
	
	protected ISourceLocation makeBinding(String scheme, String authority, String path) {
		try {
			return values.sourceLocation(scheme, authority, path);
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	private ISourceLocation createLocation(ISourceLocation loc, CodeLocation location) {
		return values.sourceLocation(loc, 
				location.getOffset(), 
				location.getLength(), 
				location.getStartLine(),
				location.getEndLine(), 
				location.getStartColumn(), 
				location.getEndColumn());
	}

	@Override
	public IValue visit(Declaration node) {
		//eval.getStdOut().println("Declaration");
		//eval.getStdOut().println("\t" + node.getProperty());
		
		IValue property = values.string(node.getProperty());

		IValueList declarationValues = new IValueList(values);
		for (Iterator<Term<?>> it = node.iterator(); it.hasNext();) {
			Term<?> t = it.next();
			IValue temp = (IValue) t.accept(this);
			declarationValues.add(temp);
		}
		
		//IValue important = constructModifierNode("important", values.bool(node.isImportant()));

		IValue decl =  constructDeclarationNode("declaration", property, declarationValues.asList());
		
		if (node.isImportant()) {
			decl = ((IConstructor) decl).asAnnotatable().setAnnotation("modifier", values.string("important"));
		}
		
		if (node.getComment() != null) {
			decl = ((IConstructor) decl).asAnnotatable().setAnnotation("comment", values.string(node.getComment().getText()));
		}

		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		decl = ((IConstructor) decl).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return decl;
	}

	@Override
	public IValue visit(CombinedSelector node) {
		//eval.getStdOut().println("CombinedSelector");

		IValueList selectors = new IValueList(values);
		for (Iterator<Selector> it = node.iterator(); it.hasNext();) {
			Selector s = it.next();
			IValue temp = (IValue) s.accept(this);
			selectors.add(temp);
		}
		//eval.getStdOut().println("CombinedSelector selectors: "+selectors.asList());
		//eval.getStdOut().println("constructTypeNode CombinedSelector");
		
		IValue val = constructExpressionNode("combinedSelector", selectors.asList());
				
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return val;
	}

	@Override
	public IValue visit(MediaExpression node) {
		//eval.getStdOut().println("MediaExpression");
		//eval.getStdOut().println(node.getFeature());
		
		IValue feature = values.string(node.getFeature());
		
		IValueList expressions = new IValueList(values);
		for (Iterator<Term<?>> it = node.iterator(); it.hasNext();) {
			Term<?> t = it.next();
			IValue temp = (IValue) t.accept(this);
			expressions.add(temp);
		}
		
		IValue val = constructExpressionNode("mediaExpression", feature, expressions.asList());
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return val;
	}

	@Override
	public IValue visit(MediaQuery node) {
		//eval.getStdOut().println("MediaQuery");
		//eval.getStdOut().println(node.getType());
		
		IValue type = values.string(node.getType());

		IValueList expressions = new IValueList(values);
		for (Iterator<MediaExpression> it = node.iterator(); it.hasNext();) {
			MediaExpression m = it.next();
			IValue temp = (IValue) m.accept(this);
			expressions.add(temp);
		}

		IValue val = constructTypeNode("mediaQuery", type, expressions.asList());
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return val;
	}

	@Override
	public IValue visit(RuleFontFace node) {
		//eval.getStdOut().println("RuleFontFace");

		IValueList declarations = new IValueList(values);
		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration d = it.next();
			IValue temp = (IValue) d.accept(this);
			declarations.add(temp);
		}
		
		IValue rule = constructStatementNode("ruleFontFace", declarations.asList());
		
		if (node.getComment() != null) {
			rule = ((IConstructor) rule).asAnnotatable().setAnnotation("comment", values.string(node.getComment().getText()));
		}
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		rule = ((IConstructor) rule).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return rule;
	}

	@Override
	public IValue visit(RuleMedia node) {
		//eval.getStdOut().println("RuleMedia");

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
		
		IValue rule = constructStatementNode("ruleMedia", mediaQueries.asList(), ruleSets.asList());
		
		if (node.getComment() != null) {
			rule = ((IConstructor) rule).asAnnotatable().setAnnotation("comment", values.string(node.getComment().getText()));
		}
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		rule = ((IConstructor) rule).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return rule;
	}

	@Override
	public IValue visit(RulePage node) {
		//eval.getStdOut().println("RulePage");
		
		IValue pseudo = values.string(node.getPseudo()+node.getName());

		IValueList declarations = new IValueList(values);
		for (Iterator<Rule<?>> it = node.iterator(); it.hasNext();) {
			Rule<?> r = it.next();
			IValue temp = (IValue) r.accept(this);
			declarations.add(temp);
		}

		IValue rule = constructStatementNode("rulePage", pseudo, declarations.asList());
		
		if (node.getComment() != null) {
			rule = ((IConstructor) rule).asAnnotatable().setAnnotation("comment", values.string(node.getComment().getText()));
		}
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		rule= ((IConstructor) rule).asAnnotatable().setAnnotation("src", nodeLocation);

		return rule;
	}

	@Override
	public IValue visit(RuleSet node) {
		//eval.getStdOut().println("RuleSet");

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
		
		IValue ruleSet = constructStatementNode("ruleSet", selectors.asList(), declarations.asList());
		
		if (node.getComment() != null) {
			ruleSet = ((IConstructor) ruleSet).asAnnotatable().setAnnotation("comment", values.string(node.getComment().getText()));
		}
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		ruleSet = ((IConstructor) ruleSet).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return ruleSet;
	}

	@Override
	public IValue visit(RuleViewport node) {
		//eval.getStdOut().println("RuleViewport");

		IValueList declarations = new IValueList(values);
		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration d = it.next();
			IValue temp = (IValue) d.accept(this);
			declarations.add(temp);
		}

		IValue rule = constructStatementNode("ruleViewport", declarations.asList());
		
		if (node.getComment() != null) {
			rule = ((IConstructor) rule).asAnnotatable().setAnnotation("comment", values.string(node.getComment().getText()));
		}
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		rule = ((IConstructor) rule).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return rule;
	}

	@Override
	public IValue visit(Selector node) {
		//eval.getStdOut().println("Selector");
		//eval.getStdOut().println("\t"+node.getCombinator());
//		
//		IValueList statements = new IValueList(values);
//		for (Iterator<RuleBlock<?>> it = node.iterator(); it.hasNext();) {
//			RuleBlock<?> r = it.next();
//			IValue temp = (IValue) r.accept(this);
//			statements.add(temp);
//		}
		
		IValueList selector = new IValueList(values);
		for (Iterator<SelectorPart> it = node.iterator(); it.hasNext();) {
			SelectorPart m = it.next();
			IValue temp = (IValue) m.accept(this);
			selector.add(temp);
		}
		
		//IValue sel = (IValue) m.accept(this);
		
		IValue val = constructExpressionNode("selector", selector.asList());
		
		if (node.getCombinator() != null) {
			//IValue combinator = constructModifierNode("combi", values.string(node.getCombinator().toString().toLowerCase()));
			//val = ((IConstructor) val).asAnnotatable().setAnnotation("combi", combinator);
			val = ((IConstructor) val).asAnnotatable().setAnnotation("combinator", values.string(node.getCombinator().toString().toLowerCase()));
		}

		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return val;
	}

	@Override
	public IValue visit(StyleSheet node) {
		ISourceLocation test = createLocation(loc, node.getLocation());
//		eval.getStdOut().println("StyleSheet");
//		eval.getStdOut().println(test);

		IValueList statements = new IValueList(values);
		for (Iterator<RuleBlock<?>> it = node.iterator(); it.hasNext();) {
			RuleBlock<?> r = it.next();
			IValue temp = (IValue) r.accept(this);
			statements.add(temp);
		}
		
		IValue stylesheet = constructStatementNode("stylesheet", values.string(node.getName()), statements.asList());
		
		if (node.getComment() != null) {
			stylesheet = ((IConstructor) stylesheet).asAnnotatable().setAnnotation("comment", values.string(node.getComment().getText()));
		}
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		stylesheet = ((IConstructor) stylesheet).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return stylesheet;
	}

	@Override
	public IValue visit(TermAngle node) {
		//eval.getStdOut().println("TermAngle");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue angle = values.real(node.getValue().doubleValue(), 2);
	    IValue unit = values.string(node.getUnit().toString());
	    
	    IValue val = constructTypeNode("angle", angle, unit);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val; 
	}
	
	@Override
	public Object visit(TermAudio node) {
		//eval.getStdOut().println("TermAudio");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue angle = values.real(node.getValue().doubleValue(), 2);
	    IValue unit = values.string(node.getUnit().toString());
	    
	    IValue val = constructTypeNode("audio", angle, unit);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val; 
	}

	@Override
	public IValue visit(TermColor node) {
		//eval.getStdOut().println("TermColor");
		//eval.getStdOut().println("\t" + node.getValue());
		
		IValue red = values.integer(node.getValue().getRed());
		IValue green = values.integer(node.getValue().getGreen());
		IValue blue = values.integer(node.getValue().getBlue());
		IValue alpha = values.real(Double.valueOf((double)((double)node.getValue().getAlpha()/(double)255.00)), 2);
		
		//eval.getStdOut().println(alpha);
		//eval.getStdOut().println(node.getValue().getAlpha());
		//eval.getStdOut().println(Double.valueOf((double)((double)node.getValue().getAlpha()/(double)255.00)));
		//eval.getStdOut().println((node.getValue().getAlpha()/255));
		
		IValue val = constructTypeNode("color", red, green, blue, alpha);
			
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val; 
	}

	@Override
	public IValue visit(TermExpression node) {
		//eval.getStdOut().println("TermExpression");
		//eval.getStdOut().println("\t" + node.getValue());
		
		IValue expression = values.string(node.getValue().toString());
		
		IValue val = constructTypeNode("expression", expression);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val;
	}

	@Override
	public IValue visit(TermFrequency node) {
		//eval.getStdOut().println("TermFrequency");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue freq = values.real(node.getValue(), 2);
		IValue unit = values.string(node.getUnit().toString());
		
		IValue val = constructTypeNode("frequency", freq, unit);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val;
	}

	@Override
	public IValue visit(TermFunction node) {
		//eval.getStdOut().println("TermFunction");
		//eval.getStdOut().println(node.getFunctionName());

		IValue functionName = values.string(node.getFunctionName());
		
		IValueList expressions = new IValueList(values);
		for (Iterator<Term<?>> it = node.iterator(); it.hasNext();) {
			Term<?> t = it.next();
			IValue temp = (IValue) t.accept(this);
			expressions.add(temp);
		}
		
		IValue val = constructTypeNode("function", functionName, expressions.asList());
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val;
	}

	@Override
	public IValue visit(TermIdent node) {
		//eval.getStdOut().println("TermIdent");
		//eval.getStdOut().println("\t" + node.getValue());
		
		IValue ident = values.string(node.getValue().toString());

		IValue val = constructTypeNode("ident", ident);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val;
	}

	@Override
	public IValue visit(TermInteger node) {
		//eval.getStdOut().println("TermInteger");
		// For some strange reason termInteger contains floats...
		//eval.getStdOut().println("\t" + node.getValue().intValue()+ " " + node.getUnit());
		
		IValue integer = values.integer(node.getValue().intValue());
		
		IValue val = constructTypeNode("integer", integer);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val; 
	}
	
	@Override
	public IValue visit(TermLength node) {
		//eval.getStdOut().println("TermLength");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue length = values.real(node.getValue().doubleValue(), 2);
		IValue unit = values.string(node.getUnit().toString());
		
		IValue val = constructTypeNode("length", length, unit);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val;
		
	}

	@Override
	public IValue visit(TermNumber node) {
		//eval.getStdOut().println("TermNumber");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue number = values.real(node.getValue(), 2);
		
		IValue val = constructTypeNode("number", number);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val;
		
	}

	@Override
	public IValue visit(TermPercent node) {
		//eval.getStdOut().println("TermPercent");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue percent = values.real(node.getValue(), 2);
		
		IValue val = constructTypeNode("percent", percent);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val;
	}

	@Override
	public IValue visit(TermResolution node) {
		//eval.getStdOut().println("TermResolution");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue resolution = values.real(node.getValue(), 2);
		IValue unit = values.string(node.getUnit().toString());
		
		IValue val = constructTypeNode("resolution", resolution, unit);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val;
		
	}

	@Override
	public IValue visit(TermString node) {
		//eval.getStdOut().println("TermString");
		//eval.getStdOut().println("\t" + node.getValue());
		
		IValue string = values.string(node.getValue().toString());
		
		IValue val = constructTypeNode("string", string);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			//eval.getStdOut().println("OPERATOR: "+ node.getOperator());
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val;
	}

	@Override
	public IValue visit(TermTime node) {
		//eval.getStdOut().println("TermTime");
		//eval.getStdOut().println("\t" + node.getValue() + " " + node.getUnit());
		
		IValue time = values.real(node.getValue(), 2);
		IValue unit = values.string(node.getUnit().toString());
		
		IValue val = constructTypeNode("time", time, unit);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val;
	}

	@Override
	public IValue visit(TermURI node) {
		//eval.getStdOut().println("TermURI");
		//eval.getStdOut().println("\t" + node.getValue());

		IValue uri = values.string(node.getValue().toString());
		
		IValue val = constructTypeNode("uri", uri);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val;
	}

	@Override
	public IValue visit(ElementAttribute node) {
		//eval.getStdOut().println("ElementAttribute");
		//eval.getStdOut().println("\t" + node.getAttribute() + " " + node.getOperator() + " " + node.getValue());
		
		IValue attribute = values.string(node.getAttribute().toString());
		
		IValue val;
		
		if (node.getValue() == null) {
			val = constructTypeNode("attributeSelector", attribute);
		} else {
			IValue operator = values.string(node.getOperator().toString());
			IValue value = values.string(node.getValue().toString());
			
			val = constructTypeNode("attributeSelector", attribute, operator, value);
		}
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return val;
	}

	@Override
	public IValue visit(ElementClass node) {
		//eval.getStdOut().println("ElementClass");
		//eval.getStdOut().println("\t" + node.getClassName());
		
		IValue className = values.string(node.getClassName().substring(1));
		
		IValue val = constructTypeNode("class", className);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return val;
	}

	@Override
	public IValue visit(ElementID node) {
		//eval.getStdOut().println("ElementID");
		//eval.getStdOut().println("\t" + node.getID());
		
		IValue idName = values.string(node.getID().substring(1));
		
		IValue val = constructTypeNode("id", idName);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return val;
	}

	@Override
	public IValue visit(ElementName node) {
		//eval.getStdOut().println("ElementName");
		//eval.getStdOut().println("\t" + node.getName());
		
		IValue elemName = values.string(node.getName());
		
		IValue val = constructTypeNode("domElement", elemName);
		
		//eval.getStdOut().println(node.getLocation().toString());
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return val;
	}

	@Override
	public IValue visit(PseudoPage node) {
		//eval.getStdOut().println("PseudoPage");
		//eval.getStdOut().println("\t" + node.getValue());
		
		IValue pseudoPage = values.string(node.getValue());
		
		IValue val;
		if (node.getDeclaration().isPseudoElement()) {
			val = constructTypeNode("pseudoElement", pseudoPage);
		} else {
			val = constructTypeNode("pseudoClass", pseudoPage);
		}
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return val;
	}

	@Override
	public Object visit(RuleImport node) {
		//eval.getStdOut().println("RuleImport");
		//eval.getStdOut().println("\t" + node.getURI());
		
		IValue uri = values.string(node.getURI());
				
		IValue rule;
		if (node.getMediaQueries().size() == 0) {
			rule = constructStatementNode("ruleImport", uri);
		} else {
			IValueList mediaQueries = new IValueList(values);
			for (Iterator<MediaQuery> it = node.getMediaQueries().iterator(); it.hasNext();) {
				MediaQuery m = it.next();
				IValue temp = (IValue) m.accept(this);
				mediaQueries.add(temp);
			}
			
			rule = constructStatementNode("ruleImport", uri, mediaQueries.asList());
		}
		
		if (node.getComment() != null) {
			rule = ((IConstructor) rule).asAnnotatable().setAnnotation("comment", values.string(node.getComment().getText()));
		}

		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		rule = ((IConstructor) rule).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return rule;
	}

	@Override
	public Object visit(CSSComment node) {
		//eval.getStdOut().println("CSSComment");
		//eval.getStdOut().println("\t" + node.getText());
		
		IValue text = values.string(node.getText());
		return constructStatementNode("comment", text);
	}

	@Override
	public Object visit(RuleCharset node) {
		//eval.getStdOut().println("RuleCharset");
		//eval.getStdOut().println("\t" + node.getCharset());
		
		IValue text = values.string(node.getCharset());
		
		IValue rule = constructStatementNode("ruleCharset", text);
		
		if (node.getComment() != null) {
			rule = ((IConstructor) rule).asAnnotatable().setAnnotation("comment", values.string(node.getComment().getText()));
		}

		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		rule = ((IConstructor) rule).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return rule;
	}

	@Override
	public Object visit(TermCalc node) {
		//eval.getStdOut().println("TermCalc");
		//eval.getStdOut().println("\t" + node.getValue());
		
		IValue expression = values.string(node.getValue().toString());
		
		IValue val = constructTypeNode("calc", expression);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		if (node.getOperator() != null) {
			IValue op = values.string(node.getOperator().value());
			val = ((IConstructor) val).asAnnotatable().setAnnotation("op", op);
		}
		
		return val;
	}

	@Override
	public Object visit(RuleCounterStyle node) {
		//eval.getStdOut().println("RuleCounterStyle");

		IValueList declarations = new IValueList(values);
		for (Iterator<Declaration> it = node.iterator(); it.hasNext();) {
			Declaration d = it.next();
			IValue temp = (IValue) d.accept(this);
			declarations.add(temp);
		}
		
		IValue name = values.string(node.getName());
		
		IValue rule = constructStatementNode("ruleCounterStyle", name, declarations.asList());
		
		if (node.getComment() != null) {
			rule = ((IConstructor) rule).asAnnotatable().setAnnotation("comment", values.string(node.getComment().getText()));
		}
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		rule = ((IConstructor) rule).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return rule;
	}

	@Override
	public Object visit(RuleNameSpace node) {
		//eval.getStdOut().println("RuleNameSpace");
		//eval.getStdOut().println("\t" + node.getUri());
		
		IValue uri = values.string(node.getUri());
		
		IValue rule;
		if (node.getPrefix().equals("")) {
			rule = constructStatementNode("ruleNameSpace", uri);
		} else {
			IValue prefix = values.string(node.getPrefix());
			rule = constructStatementNode("ruleNameSpace", prefix, uri);
		}
		
		if (node.getComment() != null) {
			rule = ((IConstructor) rule).asAnnotatable().setAnnotation("comment", values.string(node.getComment().getText()));
		}

		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		rule = ((IConstructor) rule).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return rule;
	}

	@Override
	public Object visit(KeyframesPercentage node) {
		//eval.getStdOut().println("keyframesPercentage");
		//eval.getStdOut().println("\t" + node.getPercentage());
		
		IValue percent = values.real(node.getPercentage(), 2);
		
		IValue val = constructTypeNode("percent", percent);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return val;
	}

	@Override
	public Object visit(KeyframesIdent node) {
		//eval.getStdOut().println("KeyframesIdent");
		//eval.getStdOut().println("\t" + node.getIdent());
		
		IValue ident = values.string(node.getIdent().toString());
	
		IValue val = constructTypeNode("ident", ident);
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		val = ((IConstructor) val).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return val;
	}

	@Override
	public Object visit(RuleKeyframes node) {
		//eval.getStdOut().println("RuleKeyframes");

		IValue name = values.string(node.getName().toString());

		IValueList ruleSets = new IValueList(values);
		for (Iterator<RuleSet> it = node.iterator(); it.hasNext();) {
			RuleSet r = it.next();
			IValue temp = (IValue) r.accept(this);
			ruleSets.add(temp);
		}
		
		IValue rule = constructStatementNode("ruleKeyframes", name, ruleSets.asList());
		
		if (node.getComment() != null) {
			rule = ((IConstructor) rule).asAnnotatable().setAnnotation("comment", values.string(node.getComment().getText()));
		}
		
		ISourceLocation nodeLocation = createLocation(loc, node.getLocation());
		rule = ((IConstructor) rule).asAnnotatable().setAnnotation("src", nodeLocation);
		
		return rule;
	}
}
