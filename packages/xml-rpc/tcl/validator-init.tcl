# /packages/xml-rpc/tcl/validator-init.tcl
ad_library {
     Register validator XML-RPC procs
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Fri Oct  3 19:25:19 2003
     @cvs-id $Id: validator-init.tcl,v 1.1.1.1 2006/06/29 21:11:32 cvs Exp $
}

xmlrpc::register_proc validator1.arrayOfStructsTest
xmlrpc::register_proc validator1.countTheEntities
xmlrpc::register_proc validator1.easyStructTest
xmlrpc::register_proc validator1.echoStructTest
xmlrpc::register_proc validator1.manyTypesTest
xmlrpc::register_proc validator1.moderateSizeArrayCheck
xmlrpc::register_proc validator1.nestedStructTest
xmlrpc::register_proc validator1.simpleStructReturnTest
 
