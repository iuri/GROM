<master>
<property name="title">@page_title;noquote@</property>
<property name="main_navbar_label">finance</property>
<property name="sub_navbar">@sub_navbar_html;noquote@</property>

<multiple name="active_projects">
<ul>  
<li><a href="@active_projects.project_url@">@active_projects.project_nr@</a>:
        @active_projects.project_name@
</ul></multiple>
