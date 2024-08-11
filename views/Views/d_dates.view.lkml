view: d_dates {
  sql_table_name: "DATA_MART"."D_DATES" ;;

  dimension_group: date_val {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."DATE_VAL" ;;
  }
  dimension: datekey {
    type: number
    primary_key: yes
    sql: ${TABLE}."DATEKEY" ;;
  }
  dimension: day_of_week {
    type: number
    sql: ${TABLE}."DAY_OF_WEEK" ;;
  }
  dimension: dayname_of_week {
    type: string
    sql: ${TABLE}."DAYNAME_OF_WEEK" ;;
  }
  dimension: month_name {
    type: string
    sql: ${TABLE}."MONTH_NAME" ;;
  }
  dimension: month_num {
    type: number
    sql: ${TABLE}."MONTH_NUM" ;;
  }
  dimension: quarter {
    type: number
    sql: ${TABLE}."QUARTER" ;;
  }
  dimension: year {
    type: number
    sql: ${TABLE}."YEAR" ;;
  }
  measure: count {
    type: count
    drill_fields: [month_name]
  }

  parameter:granularity {
    type: unquoted
    allowed_value: {
      value: "Month"
      label: "Month"
    }
    allowed_value:
    {value: "Quarter"
      label: "Quarter"
    }
    allowed_value:
    {value: "Year"
      label: "Year"
    }
  }

  dimension: date {
    datatype: date
    sql: ${TABLE}."DATE_VAL" ;;
  }

  dimension: Dynamic_date_filter {
    type: number
    label_from_parameter: granularity
    sql: {% parameter ${granularity} %} ${date} ;;
  }

 dimension: target_chart_name {
    label_from_parameter: granularity
    type: string
    sql: {% if granularity._parameter_value=="Month" %} 'Monthly'
         {% elsif granularity._parameter_value=="Quarter" %} 'Quarterly'
         {% elsif granularity._parameter_value=="Year" %} 'Yearly'
         {% endif %};;
  }
}
