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
    sql: ${TABLE}."C_NATION" ;;
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
  filter: customer_region {
    label: "Customer Region"
    type: string
    }
  filter: customer_nation {
    type: string
    label: "Customer Nation"
    sql: SELECT DISTINCT C_NATION FROM D_CUSTOMER WHERE C_REGION = {% condition customer_region %} {% endcondition %} ;;
    }

}
