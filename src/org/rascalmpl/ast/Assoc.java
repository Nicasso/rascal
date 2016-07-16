/*******************************************************************************
 * Copyright (c) 2009-2015 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   * Jurgen J. Vinju - Jurgen.Vinju@cwi.nl - CWI
 *   * Tijs van der Storm - Tijs.van.der.Storm@cwi.nl
 *   * Paul Klint - Paul.Klint@cwi.nl - CWI
 *   * Mark Hills - Mark.Hills@cwi.nl (CWI)
 *   * Arnold Lankamp - Arnold.Lankamp@cwi.nl
 *   * Michael Steindorfer - Michael.Steindorfer@cwi.nl - CWI
 *******************************************************************************/
package org.rascalmpl.ast;


import org.rascalmpl.value.IConstructor;
import org.rascalmpl.value.ISourceLocation;

public abstract class Assoc extends AbstractAST {
  public Assoc(ISourceLocation src, IConstructor node) {
    super(src /* we forget node on purpose */);
  }

  

  

  
  public boolean isAssociative() {
    return false;
  }

  static public class Associative extends Assoc {
    // Production: sig("Associative",[],breakable=false)
  
    
  
    public Associative(ISourceLocation src, IConstructor node ) {
      super(src, node);
      
    }
  
    @Override
    public boolean isAssociative() { 
      return true; 
    }
  
    @Override
    public <T> T accept(IASTVisitor<T> visitor) {
      return visitor.visitAssocAssociative(this);
    }
  
    @Override
    protected void addForLineNumber(int $line, java.util.List<AbstractAST> $result) {
      if (getLocation().getBeginLine() == $line) {
        $result.add(this);
      }
      ISourceLocation $l;
      
    }
  
    @Override
    public boolean equals(Object o) {
      if (!(o instanceof Associative)) {
        return false;
      }        
      Associative tmp = (Associative) o;
      return true ; 
    }
   
    @Override
    public int hashCode() {
      return 229 ; 
    } 
  
    	
  
    @Override
    public Object clone()  {
      return newInstance(getClass(), src, (IConstructor) null );
    }
            
  }
  public boolean isLeft() {
    return false;
  }

  static public class Left extends Assoc {
    // Production: sig("Left",[],breakable=false)
  
    
  
    public Left(ISourceLocation src, IConstructor node ) {
      super(src, node);
      
    }
  
    @Override
    public boolean isLeft() { 
      return true; 
    }
  
    @Override
    public <T> T accept(IASTVisitor<T> visitor) {
      return visitor.visitAssocLeft(this);
    }
  
    @Override
    protected void addForLineNumber(int $line, java.util.List<AbstractAST> $result) {
      if (getLocation().getBeginLine() == $line) {
        $result.add(this);
      }
      ISourceLocation $l;
      
    }
  
    @Override
    public boolean equals(Object o) {
      if (!(o instanceof Left)) {
        return false;
      }        
      Left tmp = (Left) o;
      return true ; 
    }
   
    @Override
    public int hashCode() {
      return 751 ; 
    } 
  
    	
  
    @Override
    public Object clone()  {
      return newInstance(getClass(), src, (IConstructor) null );
    }
            
  }
  public boolean isNonAssociative() {
    return false;
  }

  static public class NonAssociative extends Assoc {
    // Production: sig("NonAssociative",[],breakable=false)
  
    
  
    public NonAssociative(ISourceLocation src, IConstructor node ) {
      super(src, node);
      
    }
  
    @Override
    public boolean isNonAssociative() { 
      return true; 
    }
  
    @Override
    public <T> T accept(IASTVisitor<T> visitor) {
      return visitor.visitAssocNonAssociative(this);
    }
  
    @Override
    protected void addForLineNumber(int $line, java.util.List<AbstractAST> $result) {
      if (getLocation().getBeginLine() == $line) {
        $result.add(this);
      }
      ISourceLocation $l;
      
    }
  
    @Override
    public boolean equals(Object o) {
      if (!(o instanceof NonAssociative)) {
        return false;
      }        
      NonAssociative tmp = (NonAssociative) o;
      return true ; 
    }
   
    @Override
    public int hashCode() {
      return 433 ; 
    } 
  
    	
  
    @Override
    public Object clone()  {
      return newInstance(getClass(), src, (IConstructor) null );
    }
            
  }
  public boolean isRight() {
    return false;
  }

  static public class Right extends Assoc {
    // Production: sig("Right",[],breakable=false)
  
    
  
    public Right(ISourceLocation src, IConstructor node ) {
      super(src, node);
      
    }
  
    @Override
    public boolean isRight() { 
      return true; 
    }
  
    @Override
    public <T> T accept(IASTVisitor<T> visitor) {
      return visitor.visitAssocRight(this);
    }
  
    @Override
    protected void addForLineNumber(int $line, java.util.List<AbstractAST> $result) {
      if (getLocation().getBeginLine() == $line) {
        $result.add(this);
      }
      ISourceLocation $l;
      
    }
  
    @Override
    public boolean equals(Object o) {
      if (!(o instanceof Right)) {
        return false;
      }        
      Right tmp = (Right) o;
      return true ; 
    }
   
    @Override
    public int hashCode() {
      return 839 ; 
    } 
  
    	
  
    @Override
    public Object clone()  {
      return newInstance(getClass(), src, (IConstructor) null );
    }
            
  }
}