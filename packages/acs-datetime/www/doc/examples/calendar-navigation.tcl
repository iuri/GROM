# /packages/acs-datetime/www/doc/calendar-widgets.tcl

ad_page_contract {
    
    Examples of various calendar widgets

    @author  ron@arsdigita.com
    @creation-date 2000-12-08
    @cvs-id  $Id: calendar-navigation.tcl,v 1.2 2010/10/19 20:11:22 po34demo Exp $
} {
    {view ""}
    {date ""}
} -properties {
    title:onevalue
    calendar_widget:onevalue
}

set title "dt_widget_calendar_navigation"

set calendar_widget [dt_widget_calendar_navigation "" $view $date]

ad_return_template


