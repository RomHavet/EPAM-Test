view: d_supplier {
  sql_table_name: "DATA_MART"."D_SUPPLIER" ;;

  dimension: s_acctbal {
    type: number
    sql: ${TABLE}."S_ACCTBAL" ;;
  }
  dimension: s_address {
    type: string
    sql: ${TABLE}."S_ADDRESS" ;;
  }
  dimension: s_name {
    link: {
      url: "http://www.google.com/search?q={{ value | url_encode }}"
      icon_url: "http://google.com/favicon.ico"
    }
    type: string
    sql: ${TABLE}."S_NAME";
  }

  dimension: s_nation {
    type: string
    sql: ${TABLE}."S_NATION" ;;
  }
  dimension: s_phone {
    type: string
    sql: ${TABLE}."S_PHONE" ;;
  }
  dimension: s_region {
    type: string
    sql: ${TABLE}."S_REGION" ;;
  }
  dimension: s_suppkey {
    type: number
    primary_key: yes
    sql: ${TABLE}."S_SUPPKEY" ;;
  }
  dimension: c_account_balance_cohort {
    description: "distribution of suppliers by their account balance"
    type: string
    sql:
    CASE
      WHEN ${s_acctbal} <= 0 THEN '0 or less'
      WHEN ${s_acctbal} BETWEEN 1 AND 3000 THEN '1 - 3000'
      WHEN ${s_acctbal} BETWEEN 3001 AND 5000 THEN '3001 - 5000'
      WHEN ${s_acctbal} BETWEEN 5001 AND 7000 THEN '5001 - 7000'
      ELSE '7001 or more'
    END ;;
  }


  measure: count {
    type: count
    drill_fields: [s_name]
  }
}
