view: d_customer {
  sql_table_name: "DATA_MART"."D_CUSTOMER" ;;

  dimension: c_address {
    type: string
    sql: ${TABLE}."C_ADDRESS" ;;
  }
  dimension: c_custkey {
    type: number
    primary_key: yes
    sql: ${TABLE}."C_CUSTKEY" ;;
  }
  dimension: c_mktsegment {
    type: number
    sql: ${TABLE}."C_MKTSEGMENT" ;;
  }
  dimension: c_name {
    link: {
      url: "http://www.google.com/search?q={{ value | url_encode }}"
      icon_url: "http://google.com/favicon.ico"
    }
    type: string
    sql: ${TABLE}."C_NAME" ;;
  }
  dimension: c_nation {
    label: "Customer Nation"
    type: string
    sql: ${TABLE}."C_NATION";;
  }
  dimension: button {
    type: string
    link: {
      url: "/dashboards/305?&f[${c_region}]=_filters['${customer_region1}']"
      icon_url: "http://google.com/favicon.ico"
    }
  }

  dimension: c_phone {
    type: string
    sql: ${TABLE}."C_PHONE" ;;
  }
  dimension: c_region {
    label: "Customer Region"
    type: string
    sql: ${TABLE}."C_REGION" ;;
  }
  measure: count {
    type: count
    drill_fields: [c_name]
  }
  filter: customer_region1 {
    type: string
    suggest_dimension: c_region
   }


}
