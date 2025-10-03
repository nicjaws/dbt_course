{% macro learn_variables() %}
    {% set your_name_jinja= "Nico"%}
    {{ log("Hello " ~ your_name_jinja, info=True)}}
{% endmacro %}