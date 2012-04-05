ad_page_contract {
    Cancels all watches in given package.

    @author Peter Marklund
    @cvs-id $Id: package-watch-cancel.tcl,v 1.3 2010/10/19 20:10:04 po34demo Exp $
} {
    package_key
    {return_url "index"}
} 

apm_cancel_all_watches $package_key

ad_returnredirect $return_url
