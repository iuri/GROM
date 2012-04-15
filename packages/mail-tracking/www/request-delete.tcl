ad_page_contract {

    Remove a mail-tracking request

    @author Nima Mazloumi (mazloumi@uni-mannheim.de)
    @creation-date 2005-05-31
    @cvs-id $Id: request-delete.tcl,v 1.1.1.1 2007/04/29 23:37:26 cognovis Exp $
} {
    request_id:integer,notnull
    return_url
}

# Security Check
mail_tracking::security::require_admin_request -request_id $request_id

# Actually Delete
mail_tracking::request::delete -request_id $request_id

# Redirect
ad_returnredirect $return_url
