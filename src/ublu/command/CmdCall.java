/*
 * Copyright (c) 2014, Absolute Performance, Inc. http://www.absolute-performance.com
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
package ublu.command;

import ublu.util.ArgArray;
import ublu.util.Functor;
import ublu.util.Generics;
import ublu.util.Generics.TupleNameList;
import ublu.util.Tuple;
import java.util.logging.Level;

/**
 * A command to call a Functor
 *
 * @author jwoehr
 */
public class CmdCall extends Command {

    {
        setNameAndDescription("CALL", "/? @tuple ( [@parm] .. ) : Call a functor");
    }

    /**
     * Do the work of CALL
     *
     * @param argArray input args
     * @return what's left of the args
     */
    public ArgArray doCall(ArgArray argArray) {
        if (!argArray.isNextTupleName()) {
            getLogger().log(Level.SEVERE, "Need a @tuple name in {0}", getNameAndDescription());
            setCommandResult(COMMANDRESULT.FAILURE);
        } else {
            String tupleName = argArray.next();
            if (!argArray.peekNext().equals("(")) {
                getLogger().log(Level.SEVERE, "Need a  ( parameter list ) in {0}", getNameAndDescription());
                setCommandResult(COMMANDRESULT.FAILURE);
            } else {
                argArray.next(); // discard "("
                TupleNameList tnl = new Generics.TupleNameList();
                while (!argArray.peekNext().equals(")")) {
                    tnl.add(argArray.next());
                }
                argArray.next(); // discard ")"
                Tuple functorTuple = getTuple(tupleName);
                Object o = functorTuple.getValue();
                if (!(o instanceof Functor)) {
                    getLogger().log(Level.SEVERE, "Can''t get FUNctor from tuple {0} in {1}", new Object[]{tupleName, getNameAndDescription()});
                    setCommandResult(COMMANDRESULT.FAILURE);
                } else {
                    Functor f = Functor.class.cast(o);
                    // /* Debug */ System.err.println("About to CALL functor " + f.toString());
                    setCommandResult(getInterpreter().executeFunctor(Functor.class.cast(o), tnl));
                }
            }
        }
        return argArray;
    }

    @Override
    public ArgArray cmd(ArgArray args) {
        reinit();
        return doCall(args);
    }

    @Override
    public COMMANDRESULT getResult() {
        return getCommandResult();
    }
}
