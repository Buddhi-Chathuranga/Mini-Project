-----------------------------------------------------------------------------
--
--  Logical unit: AurenaClientMetadata
--  Component:    FNDBAS
--
--  Template:     3.0
--  Built by:     IFS Developer Studio 10.82.0-SNAPSHOT
--
--  NOTE! Do not edit!! This file is completely generated and will be
--        overwritten next time the corresponding JSON schema is saved.
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Client_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   version_                      VARCHAR2(4000),
   projection_                   JSON_OBJECT_T,
   component_                    VARCHAR2(4000),
   layout_                       JSON_OBJECT_T
);

TYPE Projection_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   service_                      VARCHAR2(4000),
   version_                      VARCHAR2(4000),
   contains_                     JSON_OBJECT_T,
   enumerations_                 JSON_OBJECT_T,
   entities_                     JSON_OBJECT_T,
   structures_                   JSON_OBJECT_T,
   actions_                      JSON_OBJECT_T,
   functions_                    JSON_OBJECT_T,
   objectconnections_            JSON_OBJECT_T,
   procedures_                   JSON_OBJECT_T,
   attachmentservices_           JSON_OBJECT_T
);

TYPE EntitySet_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   array_                        BOOLEAN,
   defaultfilter_                BOOLEAN,
   contexts_                     JSON_OBJECT_T,
   offlinefilter_                JSON_OBJECT_T
);

TYPE Enumeration_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   values_                       JSON_ARRAY_T,
   subsets_                      JSON_OBJECT_T,
   labels_                       JSON_ARRAY_T,
   enum_prefix_                  VARCHAR2(4000),
   lookup_encodings_             JSON_ARRAY_T
);

TYPE EnumLabel_Rec IS RECORD (
   value_                        VARCHAR2(4000),
   label_                        VARCHAR2(4000)
);

TYPE LookupEncoding_Rec IS RECORD (
   val_                          VARCHAR2(4000),
   enc_                          VARCHAR2(4000)
);

TYPE Entity_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   has_e_tag_                    BOOLEAN,
   has_keys_                     BOOLEAN,
   entitytype_                   VARCHAR2(4000),
   c_r_u_d_                      VARCHAR2(4000),
   validateaction_               VARCHAR2(4000),
   luname_                       VARCHAR2(4000),
   display_name_                 VARCHAR2(4000),
   ludependencies_               JSON_ARRAY_T,
   datavalidity_                 JSON_OBJECT_T,
   keys_                         JSON_ARRAY_T,
   syncpolicy_                   JSON_OBJECT_T,
   offline_query_                JSON_OBJECT_T,
   contextmapping_               JSON_OBJECT_T,
   contexttodefault_             JSON_OBJECT_T,
   connected_entities_           JSON_ARRAY_T,
   attributes_                   JSON_OBJECT_T,
   references_                   JSON_OBJECT_T,
   arrays_                       JSON_OBJECT_T,
   actions_                      JSON_OBJECT_T,
   functions_                    JSON_OBJECT_T,
   transaction_group_            VARCHAR2(4000),
   defaultcopyapplicable_        BOOLEAN
);

TYPE Structure_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   attributes_                   JSON_OBJECT_T,
   references_                   JSON_OBJECT_T,
   arrays_                       JSON_OBJECT_T
);

TYPE Attribute_Rec IS RECORD (
   datatype_                     VARCHAR2(4000),
   size_                         INTEGER,
   scale_                        INTEGER,
   precision_                    INTEGER,
   subtype_                      VARCHAR2(4000),
   format_                       VARCHAR2(4000),
   regexp_                       VARCHAR2(4000),
   array_                        BOOLEAN,
   keygeneration_                VARCHAR2(4000),
   validations_                  JSON_ARRAY_T,
   required_                     VARCHAR2(4000),
   editable_                     VARCHAR2(4000),
   updatable_                    VARCHAR2(4000),
   insertable_                   VARCHAR2(4000),
   unbound_                      VARCHAR2(4000),
   multiselect_                  VARCHAR2(4000),
   from_entity_                  VARCHAR2(4000)
);

TYPE Validation_Rec IS RECORD (
   expression_                   VARCHAR2(4000),
   message_                      VARCHAR2(4000)
);

TYPE EntityReference_Rec IS RECORD (
   target_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   case_                         VARCHAR2(32000),
   mapping_                      JSON_OBJECT_T,
   contexts_                     JSON_OBJECT_T,
   prefetch_                     JSON_OBJECT_T,
   copy_                         JSON_OBJECT_T,
   existcheck_                   BOOLEAN,
   wildcard_                     VARCHAR2(4000),
   offlinefilter_                JSON_OBJECT_T
);

TYPE Action_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   ludependencies_               JSON_ARRAY_T,
   transaction_group_            VARCHAR2(4000),
   syncpolicy_                   JSON_OBJECT_T,
   return_type_                  JSON_OBJECT_T,
   modifies_                     JSON_OBJECT_T,
   parameters_                   JSON_ARRAY_T,
   state_transition_             BOOLEAN,
   checkpoint_                   VARCHAR2(4000),
   legacy_checkpoints_           JSON_ARRAY_T,
   checkpoints_active_           VARCHAR2(4000)
);

TYPE ModifiesValues_Rec IS RECORD (
   expression_                   VARCHAR2(4000),
   invalidates_                  VARCHAR2(4000)
);

TYPE Parameter_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   data_type_                    VARCHAR2(4000),
   sub_type_                     VARCHAR2(4000),
   true_value_                   VARCHAR2(4000),
   false_value_                  VARCHAR2(4000),
   scale_                        VARCHAR2(4000),
   precision_                    VARCHAR2(4000),
   collection_                   BOOLEAN,
   nullable_                     BOOLEAN
);

TYPE Function_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   ludependencies_               JSON_ARRAY_T,
   alterattributes_              JSON_ARRAY_T,
   syncpolicy_                   JSON_OBJECT_T,
   return_type_                  JSON_OBJECT_T,
   parameters_                   JSON_ARRAY_T
);

TYPE MethodReturnType_Rec IS RECORD (
   data_type_                    VARCHAR2(4000),
   sub_type_                     VARCHAR2(4000),
   true_value_                   VARCHAR2(4000),
   false_value_                  VARCHAR2(4000),
   collection_                   BOOLEAN
);

TYPE DataValidity_Rec IS RECORD (
   type_                         VARCHAR2(4000),
   validfromcolumn_              VARCHAR2(4000),
   validtocolumn_                VARCHAR2(4000)
);

TYPE FilterEvaluation_Rec IS RECORD (
   dummy_                        VARCHAR2(4000)
);

TYPE OfflineSyncpolicy_Rec IS RECORD (
   type_                         VARCHAR2(4000)
);

TYPE Syncpolicy_Rec IS RECORD (
   type_                         VARCHAR2(4000),
   default_schedule_             JSON_OBJECT_T,
   cache_invalidation_           JSON_OBJECT_T
);

TYPE SyncSchedule_Rec IS RECORD (
   interval_                     VARCHAR2(4000),
   time_                         VARCHAR2(4000),
   days_                         JSON_ARRAY_T
);

TYPE SyncCacheInvalidation_Rec IS RECORD (
   interval_                     VARCHAR2(4000),
   time_                         INTEGER,
   period_                       VARCHAR2(4000)
);

TYPE Procedure_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   type_                         VARCHAR2(4000),
   params_                       JSON_ARRAY_T,
   layers_                       JSON_ARRAY_T
);

TYPE ProcedureParameter_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   datatype_                     VARCHAR2(4000),
   subtype_                      VARCHAR2(4000),
   true_value_                   VARCHAR2(4000),
   false_value_                  VARCHAR2(4000),
   scale_                        INTEGER,
   precision_                    INTEGER,
   collection_                   BOOLEAN
);

TYPE ProcedureLayer_Rec IS RECORD (
   vars_                         JSON_ARRAY_T,
   execute_                      JSON_ARRAY_T
);

TYPE ProcedureVariable_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   data_type_                    VARCHAR2(4000),
   sub_type_                     VARCHAR2(4000),
   true_value_                   VARCHAR2(4000),
   false_value_                  VARCHAR2(4000),
   scale_                        INTEGER,
   precision_                    INTEGER,
   collection_                   BOOLEAN
);

TYPE ProcedureExecution_Rec IS RECORD (
   dummy_                        VARCHAR2(4000)
);

TYPE OfflineQuery_Rec IS RECORD (
   from_                         JSON_OBJECT_T,
   joins_                        JSON_ARRAY_T,
   where_                        JSON_OBJECT_T,
   select_                       JSON_OBJECT_T
);

TYPE OfflineQueryFromClause_Rec IS RECORD (
   entity_                       VARCHAR2(4000),
   alias_                        VARCHAR2(4000)
);

TYPE OfflineQueryJoinClause_Rec IS RECORD (
   dummy_                        VARCHAR2(4000)
);

TYPE OfflineQueryWhereClause_Rec IS RECORD (
   dummy_                        VARCHAR2(4000)
);

TYPE OfflineQuerySelectClause_Rec IS RECORD (
   dummy_                        VARCHAR2(4000)
);

TYPE Layout_Rec IS RECORD (
   assistants_                   JSON_OBJECT_T,
   barcharts_                    JSON_OBJECT_T,
   boxmatrices_                  JSON_OBJECT_T,
   calendars_                    JSON_OBJECT_T,
   cards_                        JSON_OBJECT_T,
   searchcontexts_               JSON_OBJECT_T,
   dialogs_                      JSON_OBJECT_T,
   fields_                       JSON_OBJECT_T,
   fieldsets_                    JSON_OBJECT_T,
   ganttcharts_                  JSON_OBJECT_T,
   ganttchartitems_              JSON_OBJECT_T,
   ganttchartrows_               JSON_OBJECT_T,
   ganttchartitemstyles_         JSON_OBJECT_T,
   ganttchartrowicons_           JSON_OBJECT_T,
   ganttdependencys_             JSON_OBJECT_T,
   ganttcharttimemarkers_        JSON_OBJECT_T,
   ganttchart_schedules_         JSON_OBJECT_T,
   ganttchartlegends_            JSON_OBJECT_T,
   groups_                       JSON_OBJECT_T,
   imageviewers_                 JSON_OBJECT_T,
   processviewers_               JSON_OBJECT_T,
   linecharts_                   JSON_OBJECT_T,
   lists_                        JSON_OBJECT_T,
   pages_                        JSON_OBJECT_T,
   piecharts_                    JSON_OBJECT_T,
   radarcharts_                  JSON_OBJECT_T,
   stackedcalendars_             JSON_OBJECT_T,
   selectors_                    JSON_OBJECT_T,
   singletons_                   JSON_OBJECT_T,
   sheets_                       JSON_OBJECT_T,
   stackedcharts_                JSON_OBJECT_T,
   trees_                        JSON_OBJECT_T,
   stateindicators_              JSON_OBJECT_T,
   timelines_                    JSON_OBJECT_T,
   yearviews_                    JSON_OBJECT_T,
   commands_                     JSON_OBJECT_T
);

TYPE Chart_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   collapsed_                    BOOLEAN,
   height_                       VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T
);

TYPE ChartAxisColumn_Rec IS RECORD (
   attribute_                    VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000)
);

TYPE ChartElementOverride_Rec IS RECORD (
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   collapsed_                    VARCHAR2(4000),
   visible_                      VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T
);

TYPE PiechartElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   piechart_                     VARCHAR2(4000),
   id_                           VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   detail_page_                  VARCHAR2(4000),
   override_                     JSON_OBJECT_T
);

TYPE Piechart_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   collapsed_                    BOOLEAN,
   height_                       VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T,
   center_label_                 BOOLEAN,
   top_n_                        JSON_OBJECT_T,
   series_                       JSON_OBJECT_T
);

TYPE PieSeries_Rec IS RECORD (
   axis_label_                   VARCHAR2(4000),
   argument_column_              VARCHAR2(4000),
   argument_value_               VARCHAR2(4000)
);

TYPE TopN_Rec IS RECORD (
   mode_                         VARCHAR2(4000),
   value_                        NUMBER,
   show_others_                  BOOLEAN
);

TYPE BarchartElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   barchart_                     VARCHAR2(4000),
   id_                           VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   detail_page_                  VARCHAR2(4000),
   override_                     JSON_OBJECT_T
);

TYPE Barchart_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   collapsed_                    BOOLEAN,
   height_                       VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T,
   orientation_                  VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T,
   series_                       JSON_OBJECT_T
);

TYPE BarchartSeries_Rec IS RECORD (
   x_column_                     JSON_OBJECT_T,
   y_column_                     JSON_OBJECT_T,
   split_column_                 JSON_OBJECT_T,
   top_n_                        JSON_OBJECT_T
);

TYPE BarchartXColumn_Rec IS RECORD (
   axis_label_                   VARCHAR2(4000),
   column_                       JSON_OBJECT_T
);

TYPE BarchartYColumn_Rec IS RECORD (
   axis_label_                   VARCHAR2(4000),
   content_                      JSON_ARRAY_T
);

TYPE BarchartYColumnContent_Rec IS RECORD (
   column_                       JSON_OBJECT_T
);

TYPE BarchartSplitColumn_Rec IS RECORD (
   content_                      JSON_ARRAY_T
);

TYPE BarchartSplitColumnContent_Rec IS RECORD (
   column_                       JSON_OBJECT_T
);

TYPE StackedchartElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   stackedchart_                 VARCHAR2(4000),
   id_                           VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   detail_page_                  VARCHAR2(4000),
   override_                     JSON_OBJECT_T
);

TYPE Stackedchart_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   collapsed_                    BOOLEAN,
   height_                       VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T,
   orientation_                  VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T,
   series_                       JSON_OBJECT_T,
   full_stacked_                 BOOLEAN
);

TYPE LinechartElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   linechart_                    VARCHAR2(4000),
   id_                           VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   detail_page_                  VARCHAR2(4000),
   override_                     JSON_OBJECT_T
);

TYPE Linechart_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   collapsed_                    BOOLEAN,
   height_                       VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T,
   orientation_                  VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T,
   series_                       JSON_OBJECT_T
);

TYPE RadarchartElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   radarchart_                   VARCHAR2(4000),
   id_                           VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   detail_page_                  VARCHAR2(4000),
   override_                     JSON_OBJECT_T
);

TYPE Radarchart_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   collapsed_                    BOOLEAN,
   height_                       VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T,
   transposed_                   BOOLEAN,
   series_                       JSON_OBJECT_T
);

TYPE RadarchartSeries_Rec IS RECORD (
   x_column_                     JSON_OBJECT_T,
   y_column_                     JSON_OBJECT_T
);

TYPE RadarchartSeriesYColumn_Rec IS RECORD (
   content_                      JSON_ARRAY_T
);

TYPE RadarchartSeriesColumn_Rec IS RECORD (
   column_                       JSON_OBJECT_T
);

TYPE RadarchartSeriesColumnContent_Rec IS RECORD (
   attribute_                    VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T
);

TYPE Ganttchart_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T
);

TYPE GanttchartElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   ganttchart_                   VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE GanttchartItem_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T
);

TYPE GanttchartItemElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   ganttchartitem_               VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE GanttchartRow_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T
);

TYPE GanttchartRowElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   ganttchartrow_                VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE GanttchartItemStyle_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T
);

TYPE GanttchartItemStyleElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   ganttchartitemstyle_          VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE GanttchartRowIcon_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T
);

TYPE GanttchartRowIconElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   ganttchartrowicon_            VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE GanttDependency_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T
);

TYPE GanttDependencyElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   ganttdependency_              VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE GanttchartTimemarker_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T
);

TYPE GanttchartTimemarkerElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   ganttcharttimemarker_         VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE GanttchartSchedule_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T
);

TYPE GanttchartScheduleElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   ganttchartschedule_           VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE GanttchartLegend_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T
);

TYPE GanttchartLegendElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   ganttchartlegend_             VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE TreeView_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   editmode_                     VARCHAR2(4000),
   staticlabel_                  VARCHAR2(4000),
   additionalcontext_            JSON_ARRAY_T,
   crudactions_                  JSON_OBJECT_T,
   datasource_                   VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   searchcontext_                JSON_ARRAY_T,
   ganttchart_                   JSON_ARRAY_T,
   defaultfilter_                VARCHAR2(4000),
   stateindicator_               VARCHAR2(4000),
   attachments_                  JSON_OBJECT_T,
   media_                        JSON_OBJECT_T,
   content_                      JSON_ARRAY_T,
   commands_                     JSON_ARRAY_T,
   commandgroups_                JSON_ARRAY_T,
   url_                          VARCHAR2(4000),
   nodes_                        JSON_ARRAY_T
);

TYPE TreeViewNode_Rec IS RECORD (
   node_                         JSON_OBJECT_T
);

TYPE TreeNode_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   root_                         BOOLEAN,
   entity_                       VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   url_                          VARCHAR2(4000),
   iconset_                      JSON_ARRAY_T,
   navigate_                     JSON_ARRAY_T,
   connections_                  JSON_ARRAY_T
);

TYPE TreeNodeIcon_Rec IS RECORD (
   icon_                         JSON_OBJECT_T
);

TYPE TreeNodeIconDetails_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   expresssion_                  VARCHAR2(4000)
);

TYPE TreeNodeNavigation_Rec IS RECORD (
   url_                          VARCHAR2(4000),
   expression_                   VARCHAR2(4000),
   default_                      BOOLEAN
);

TYPE TreeNodeConnection_Rec IS RECORD (
   connection_                   JSON_OBJECT_T
);

TYPE TreeNodeConnectionType_Rec IS RECORD (
   type_                         VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE TreeNodeConnectionBinding_Rec IS RECORD (
   bindname_                     VARCHAR2(4000),
   property_                     VARCHAR2(4000)
);

TYPE Assistant_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   staticlabel_                  VARCHAR2(4000),
   additionalcontext_            JSON_ARRAY_T,
   savemode_                     VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   structure_                    VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   auto_restart_                 VARCHAR2(4000),
   setups_                       JSON_OBJECT_T,
   init_command_                 JSON_OBJECT_T,
   back_command_                 JSON_OBJECT_T,
   steps_                        JSON_ARRAY_T,
   final_                        JSON_OBJECT_T,
   cancel_                       JSON_OBJECT_T,
   finish_command_               JSON_OBJECT_T,
   cancel_command_               JSON_OBJECT_T,
   restart_command_              JSON_OBJECT_T
);

TYPE Step_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   showlabel_                    BOOLEAN,
   description_                  VARCHAR2(4000),
   skipattribute_                VARCHAR2(4000),
   enabled_                      VARCHAR2(4000),
   optional_                     VARCHAR2(4000),
   visible_                      VARCHAR2(4000),
   valid_                        VARCHAR2(4000),
   content_                      JSON_ARRAY_T,
   next_command_                 JSON_OBJECT_T,
   skip_command_                 JSON_OBJECT_T,
   commands_                     JSON_ARRAY_T
);

TYPE BoxMatrix_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   card_                         VARCHAR2(4000),
   boximage_                     JSON_OBJECT_T,
   boxvalue_                     VARCHAR2(4000),
   boxtitle_                     VARCHAR2(4000),
   description_                  VARCHAR2(4000),
   initialview_                  VARCHAR2(4000),
   count_                        VARCHAR2(4000),
   xaxis_                        JSON_OBJECT_T,
   yaxis_                        JSON_OBJECT_T,
   select_attributes_            JSON_ARRAY_T
);

TYPE BoxMatrixAxis_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   attribute_                    VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T,
   map_                          VARCHAR2(4000)
);

TYPE BoxMatrixImage_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   attribute_                    VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T
);

TYPE BoxMatrixElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   box_matrix_                   VARCHAR2(4000)
);

TYPE Calendar_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   slot_tick_                    INTEGER,
   visible_                      VARCHAR2(4000),
   schedule_                     JSON_OBJECT_T,
   resources_                    JSON_OBJECT_T,
   orientation_                  VARCHAR2(4000),
   grouping_                     JSON_OBJECT_T,
   events_                       JSON_OBJECT_T,
   commands_                     JSON_ARRAY_T,
   commandgroups_                JSON_ARRAY_T,
   create_                       JSON_OBJECT_T,
   edit_                         JSON_OBJECT_T,
   delete_                       JSON_OBJECT_T
);

TYPE CalendarSchedule_Rec IS RECORD (
   entity_                       VARCHAR2(4000),
   workdaystart_                 VARCHAR2(4000),
   workdayend_                   VARCHAR2(4000),
   weekstart_                    VARCHAR2(4000),
   yearstart_                    VARCHAR2(4000)
);

TYPE CalendarResource_Rec IS RECORD (
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   filter_                       BOOLEAN,
   ranking_                      VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T
);

TYPE CalendarGrouping_Rec IS RECORD (
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   ranking_                      VARCHAR2(4000),
   contact_widget_               JSON_OBJECT_T
);

TYPE CalendarEvent_Rec IS RECORD (
   card_                         VARCHAR2(4000),
   allday_                       VARCHAR2(4000),
   keys_                         JSON_ARRAY_T,
   start_                        VARCHAR2(4000),
   end_                          VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T,
   views_                        JSON_OBJECT_T
);

TYPE CalendarView_Rec IS RECORD (
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   showlabel_                    BOOLEAN,
   all_day_label_                VARCHAR2(4000),
   content_                      JSON_ARRAY_T,
   timemarker_                   BOOLEAN,
   emphasis_                     JSON_ARRAY_T
);

TYPE CalendarContentRow_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   field_                        JSON_OBJECT_T
);

TYPE CalendarContentField_Rec IS RECORD (
   control_                      VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   datatype_                     VARCHAR2(4000),
   enumeration_                  VARCHAR2(4000),
   truelabel_                    VARCHAR2(4000),
   falselabel_                   VARCHAR2(4000),
   attribute_                    VARCHAR2(4000),
   visible_                      VARCHAR2(4000)
);

TYPE CalendarElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   calendar_                     VARCHAR2(4000),
   id_                           VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   override_                     JSON_OBJECT_T
);

TYPE CalendarElementOverride_Rec IS RECORD (
   details_                      VARCHAR2(4000)
);

TYPE Card_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   showlabel_                    BOOLEAN,
   datasource_                   VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   content_                      JSON_ARRAY_T,
   visible_                      VARCHAR2(4000),
   fieldranking_                 JSON_ARRAY_T,
   commands_                     JSON_ARRAY_T,
   commandgroups_                JSON_ARRAY_T
);

TYPE CardElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   card_                         VARCHAR2(4000),
   datasource_                   VARCHAR2(4000)
);

TYPE Diagram_Rec IS RECORD (
   content_                      JSON_OBJECT_T,
   displaylevels_                JSON_OBJECT_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000)
);

TYPE DiagramContent_Rec IS RECORD (
   nodes_                        JSON_OBJECT_T
);

TYPE DiagramNodes_Rec IS RECORD (
   node_                         JSON_ARRAY_T
);

TYPE DiagramDisplayLevels_Rec IS RECORD (
   above_                        NUMBER,
   below_                        NUMBER
);

TYPE DiagramNode_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   navigate_                     VARCHAR2(4000),
   card_                         VARCHAR2(4000),
   zoomlevels_                   JSON_OBJECT_T,
   connections_                  JSON_OBJECT_T,
   links_                        JSON_ARRAY_T
);

TYPE DiagramZoomLevels_Rec IS RECORD (
   small_                        JSON_OBJECT_T,
   medium_                       JSON_OBJECT_T,
   large_                        JSON_OBJECT_T
);

TYPE DiagramZoomLevelRows_Rec IS RECORD (
   rows_                         JSON_ARRAY_T
);

TYPE DiagramConnections_Rec IS RECORD (
   connection_                   JSON_ARRAY_T
);

TYPE DiagramConnection_Rec IS RECORD (
   reverse_                      BOOLEAN,
   type_                         VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE DiagramLinks_Rec IS RECORD (
   link_                         JSON_OBJECT_T
);

TYPE DiagramLink_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   entity_                       VARCHAR2(4000)
);

TYPE DiagramElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   diagram_                      VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE Dialog_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   structure_                    VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   size_                         VARCHAR2(4000),
   init_                         JSON_ARRAY_T,
   content_                      JSON_ARRAY_T,
   dialoginputdefinition_        JSON_ARRAY_T,
   dialogoutputdefinition_       JSON_ARRAY_T,
   commands_                     JSON_ARRAY_T,
   commandgroups_                JSON_ARRAY_T
);

TYPE FieldElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   field_                        JSON_OBJECT_T
);

TYPE Field_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   attribute_                    VARCHAR2(4000),
   control_                      VARCHAR2(4000),
   valuefield_                   VARCHAR2(4000),
   unitfield_                    VARCHAR2(4000),
   uniteditable_                 VARCHAR2(4000),
   unitrequired_                 VARCHAR2(4000),
   unitvisible_                  VARCHAR2(4000),
   unitdatatype_                 VARCHAR2(4000),
   unitexportlabel_              VARCHAR2(4000),
   structure_                    VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   filterlabel_                  VARCHAR2(4000),
   showlabel_                    BOOLEAN,
   truelabel_                    VARCHAR2(4000),
   falselabel_                   VARCHAR2(4000),
   icon_                         VARCHAR2(4000),
   style_                        VARCHAR2(4000),
   image_                        VARCHAR2(4000),
   mime_type_                    VARCHAR2(4000),
   expression_                   VARCHAR2(4000),
   datatype_                     VARCHAR2(4000),
   enumeration_                  VARCHAR2(4000),
   reference_                    VARCHAR2(4000),
   view_                         JSON_OBJECT_T,
   lov_                          JSON_OBJECT_T,
   lovswitch_                    JSON_ARRAY_T,
   update_                       JSON_OBJECT_T,
   detail_page_                  VARCHAR2(4000),
   controlsize_                  VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T,
   array_                        BOOLEAN,
   maxlength_                    NUMBER,
   format_                       VARCHAR2(4000),
   multiline_                    BOOLEAN,
   editable_                     VARCHAR2(4000),
   required_                     VARCHAR2(4000),
   visible_                      VARCHAR2(4000),
   searchable_                   BOOLEAN,
   column_visible_               VARCHAR2(4000),
   preserve_precision_           BOOLEAN,
   column_exclude_               VARCHAR2(4000),
   rating_                       JSON_OBJECT_T,
   colorpicker_                  JSON_OBJECT_T,
   qattributes_                  JSON_OBJECT_T,
   enabled_                      VARCHAR2(4000),
   daterange_                    JSON_OBJECT_T,
   ranking_                      NUMBER,
   contact_widget_               JSON_OBJECT_T,
   validate_command_             JSON_OBJECT_T,
   totalvalue_                   JSON_OBJECT_T,
   content_                      JSON_ARRAY_T
);

TYPE QAttributes_Rec IS RECORD (
   qflags_                       VARCHAR2(4000),
   qdatatype_                    VARCHAR2(4000)
);

TYPE Lov_Rec IS RECORD (
   selector_                     VARCHAR2(4000),
   advancedview_                 VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   search_                       JSON_ARRAY_T,
   mapping_                      JSON_OBJECT_T,
   datasource_projection_        VARCHAR2(4000),
   datasource_lookup_            VARCHAR2(4000),
   wildcards_                    JSON_ARRAY_T
);

TYPE WildCards_Rec IS RECORD (
   key_                          VARCHAR2(4000),
   description_                  VARCHAR2(4000)
);

TYPE LovSwitch_Rec IS RECORD (
   case_                         VARCHAR2(4000),
   reference_                    VARCHAR2(4000),
   lov_                          JSON_OBJECT_T,
   update_                       JSON_OBJECT_T
);

TYPE DateRange_Rec IS RECORD (
   start_date_                   JSON_OBJECT_T,
   end_date_                     JSON_OBJECT_T
);

TYPE DateRangeAttribute_Rec IS RECORD (
   attribute_                    VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000)
);

TYPE AttributeUpdate_Rec IS RECORD (
   datasource_                   VARCHAR2(4000),
   copy_                         JSON_OBJECT_T,
   fetch_                        JSON_OBJECT_T,
   item_                         VARCHAR2(4000)
);

TYPE FieldView_Rec IS RECORD (
   description_                  VARCHAR2(4000),
   card_                         VARCHAR2(4000),
   template_                     VARCHAR2(4000),
   hide_key_                     VARCHAR2(4000)
);

TYPE ContactWidget_Rec IS RECORD (
   enabled_                      VARCHAR2(4000),
   source_                       JSON_OBJECT_T,
   key_                          VARCHAR2(4000)
);

TYPE ContactWidgetSource_Rec IS RECORD (
   person_                       VARCHAR2(4000),
   customer_                     VARCHAR2(4000),
   supplier_                     VARCHAR2(4000)
);

TYPE DatasourceReference_Rec IS RECORD (
   datasource_                   VARCHAR2(4000)
);

TYPE Rating_Rec IS RECORD (
   showlabel_                    BOOLEAN,
   maxrating_                    VARCHAR2(4000)
);

TYPE FieldContent_Rec IS RECORD (
   column_                       JSON_OBJECT_T
);

TYPE ProgressElement_Rec IS RECORD (
   attribute_                    VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   value_label_                  VARCHAR2(4000),
   value_label_attribute_        VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T
);

TYPE ColorPicker_Rec IS RECORD (
   defaultemphasis_              VARCHAR2(4000)
);

TYPE FieldSetElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   fieldset_                     VARCHAR2(4000),
   id_                           VARCHAR2(4000)
);

TYPE FieldSet_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   entity_                       VARCHAR2(4000),
   content_                      JSON_ARRAY_T
);

TYPE FileSelector_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   enabled_                      VARCHAR2(4000),
   multiple_                     BOOLEAN,
   init_command_                 JSON_OBJECT_T,
   on_file_select_command_       JSON_OBJECT_T,
   on_file_delete_command_       JSON_OBJECT_T
);

TYPE FileSelectorElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   fileselector_                 JSON_OBJECT_T
);

TYPE Group_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   showlabel_                    BOOLEAN,
   datasource_                   VARCHAR2(4000),
   structure_                    VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   visible_                      VARCHAR2(4000),
   collapsed_                    VARCHAR2(4000),
   content_                      JSON_ARRAY_T,
   commands_                     JSON_ARRAY_T,
   commandgroups_                JSON_ARRAY_T
);

TYPE GroupElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   group_                        VARCHAR2(4000),
   id_                           VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   override_                     JSON_OBJECT_T
);

TYPE InlineGroupElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   group_                        JSON_OBJECT_T
);

TYPE Imageviewer_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   collapsed_                    VARCHAR2(4000),
   scaling_mode_                 VARCHAR2(4000),
   height_                       VARCHAR2(4000),
   default_image_                VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   documents_                    JSON_OBJECT_T,
   media_                        JSON_OBJECT_T,
   images_                       JSON_ARRAY_T
);

TYPE ImagePath_Rec IS RECORD (
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   url_                          VARCHAR2(4000)
);

TYPE DocumentsSetting_Rec IS RECORD (
   enabled_                      VARCHAR2(4000)
);

TYPE ImageviewerElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   imageviewer_                  VARCHAR2(4000),
   id_                           VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   override_                     JSON_OBJECT_T
);

TYPE ImageviewerElementOverride_Rec IS RECORD (
   visible_                      VARCHAR2(4000)
);

TYPE ListElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   list_                         VARCHAR2(4000),
   id_                           VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   detail_page_                  VARCHAR2(4000),
   override_                     JSON_OBJECT_T
);

TYPE List_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   visible_                      VARCHAR2(4000),
   preselect_                    VARCHAR2(4000),
   multiselect_                  VARCHAR2(4000),
   editmode_                     VARCHAR2(4000),
   initialview_                  VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T,
   singlerecordedit_             VARCHAR2(4000),
   disable_                      VARCHAR2(4000),
   collapsed_                    VARCHAR2(4000),
   favoritecolumn_               VARCHAR2(4000),
   crudactions_                  JSON_OBJECT_T,
   card_                         VARCHAR2(4000),
   boxmatrix_                    VARCHAR2(4000),
   searchcontext_                JSON_ARRAY_T,
   content_                      JSON_ARRAY_T,
   fieldranking_                 JSON_ARRAY_T,
   verticalmode_                 JSON_ARRAY_T,
   summary_                      JSON_ARRAY_T,
   commands_                     JSON_ARRAY_T,
   commandgroups_                JSON_ARRAY_T
);

TYPE MarkdownText_Rec IS RECORD (
   id_                           VARCHAR2(4000),
   text_                         VARCHAR2(4000),
   visible_                      VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T,
   select_attributes_            JSON_ARRAY_T
);

TYPE MarkdownTextElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   markdowntext_                 JSON_OBJECT_T
);

TYPE Page_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   editmode_                     VARCHAR2(4000),
   staticlabel_                  VARCHAR2(4000),
   additionalcontext_            JSON_ARRAY_T,
   crudactions_                  JSON_OBJECT_T,
   datasource_                   VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   searchcontext_                JSON_ARRAY_T,
   ganttchart_                   JSON_ARRAY_T,
   defaultfilter_                VARCHAR2(4000),
   stateindicator_               VARCHAR2(4000),
   attachments_                  JSON_OBJECT_T,
   media_                        JSON_OBJECT_T,
   content_                      JSON_ARRAY_T,
   commands_                     JSON_ARRAY_T,
   commandgroups_                JSON_ARRAY_T
);

TYPE Plugin_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   context_                      VARCHAR2(4000),
   path_                         VARCHAR2(4000),
   height_                       VARCHAR2(4000),
   collapsed_                    VARCHAR2(4000)
);

TYPE PluginElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   plugin_                       VARCHAR2(4000),
   override_                     JSON_OBJECT_T
);

TYPE PluginElementOverride_Rec IS RECORD (
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   collapsed_                    VARCHAR2(4000)
);

TYPE Processviewer_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   activestage_                  VARCHAR2(4000),
   entity_                       VARCHAR2(4000)
);

TYPE ProcessviewerElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   processviewer_                VARCHAR2(4000),
   content_                      JSON_ARRAY_T,
   override_                     JSON_OBJECT_T
);

TYPE ProcessviewerElementOverride_Rec IS RECORD (
   visible_                      VARCHAR2(4000)
);

TYPE StackedCalendar_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   weekstart_                    VARCHAR2(4000),
   weeklength_                   VARCHAR2(4000),
   reports_                      JSON_OBJECT_T,
   days_info_                    JSON_OBJECT_T,
   attendance_                   JSON_OBJECT_T,
   to_report_                    JSON_OBJECT_T,
   commands_                     VARCHAR2(4000),
   commandgroups_                JSON_OBJECT_T
);

TYPE StackedCalendarReportsArray_Rec IS RECORD (
   array_name_                   VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   date_                         VARCHAR2(4000),
   duration_                     VARCHAR2(4000),
   grouping_                     JSON_OBJECT_T,
   update_command_               JSON_OBJECT_T,
   delete_command_               JSON_OBJECT_T,
   create_command_               JSON_OBJECT_T,
   copy_command_                 JSON_OBJECT_T
);

TYPE StackedCalendarGroupingArray_Rec IS RECORD (
   primary_                      VARCHAR2(4000),
   secondary_                    VARCHAR2(4000)
);

TYPE StackedCalendarAttendanceArray_Rec IS RECORD (
   array_name_                   VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   date_                         VARCHAR2(4000),
   duration_                     VARCHAR2(4000),
   description_attribute_        VARCHAR2(4000),
   grouping_                     JSON_OBJECT_T,
   type_attribute_               VARCHAR2(4000),
   report_types_                 JSON_ARRAY_T,
   wage_types_                   JSON_ARRAY_T,
   wage_types_colors_            JSON_OBJECT_T,
   list_types_                   JSON_ARRAY_T,
   update_command_               JSON_OBJECT_T,
   delete_command_               JSON_OBJECT_T,
   create_command_               JSON_OBJECT_T,
   copy_command_                 JSON_OBJECT_T
);

TYPE StackedCalendarDaysInfoArray_Rec IS RECORD (
   array_name_                   VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   date_                         VARCHAR2(4000),
   duration_                     VARCHAR2(4000),
   update_note_command_          JSON_OBJECT_T
);

TYPE StackedCalendarToReportArray_Rec IS RECORD (
   array_name_                   VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   date_                         VARCHAR2(4000),
   wage_left_                    VARCHAR2(4000),
   job_left_                     VARCHAR2(4000)
);

TYPE StackedCalendarElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   stacked_calendar_             VARCHAR2(4000)
);

TYPE SelectorElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   selector_                     VARCHAR2(4000),
   id_                           VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE Selector_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T,
   crudactions_                  JSON_OBJECT_T,
   content_                      JSON_ARRAY_T,
   commands_                     JSON_ARRAY_T,
   commandgroups_                JSON_ARRAY_T
);

TYPE Singleton_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   entity_                       VARCHAR2(4000)
);

TYPE SingletonElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   singleton_                    VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE Sheet_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   content_                      JSON_ARRAY_T
);

TYPE SheetElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   sheet_                        VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   override_                     JSON_OBJECT_T
);

TYPE SearchContext_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T,
   content_                      JSON_ARRAY_T
);

TYPE SearchContextElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   searchcontext_                VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T
);

TYPE StateIndicator_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   control_                      VARCHAR2(4000),
   stateattribute_               VARCHAR2(4000),
   states_                       JSON_ARRAY_T
);

TYPE State_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T,
   completed_                    NUMBER,
   group_                        JSON_ARRAY_T
);

TYPE Timeline_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   collapsed_                    VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   orderby_                      JSON_ARRAY_T,
   timefield_                    VARCHAR2(4000),
   header_                       VARCHAR2(4000),
   description_                  VARCHAR2(4000),
   contact_widget_               JSON_OBJECT_T,
   show_year_                    BOOLEAN,
   show_month_                   BOOLEAN,
   card_                         VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T,
   legends_                      JSON_ARRAY_T
);

TYPE TimelineElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   timeline_                     VARCHAR2(4000),
   datasource_                   VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   detail_page_                  VARCHAR2(4000),
   override_                     JSON_OBJECT_T
);

TYPE YearView_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   visible_                      VARCHAR2(4000),
   schedule_                     JSON_OBJECT_T,
   resources_                    JSON_OBJECT_T,
   commands_                     JSON_ARRAY_T
);

TYPE YearViewElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   id_                           VARCHAR2(4000),
   yearview_                     VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   detail_page_                  VARCHAR2(4000)
);

TYPE Command_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   binding_                      JSON_OBJECT_T,
   structure_                    VARCHAR2(4000),
   entity_                       VARCHAR2(4000),
   select_attributes_            JSON_ARRAY_T,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T,
   icon_                         VARCHAR2(4000),
   style_                        VARCHAR2(4000),
   selection_                    VARCHAR2(4000),
   enabled_                      VARCHAR2(4000),
   autosave_                     VARCHAR2(4000),
   visible_                      VARCHAR2(4000),
   vars_                         JSON_OBJECT_T,
   context_                      VARCHAR2(4000),
   execute_                      JSON_ARRAY_T
);

TYPE Variable_Rec IS RECORD (
   datatype_                     VARCHAR2(4000)
);

TYPE Execute_Rec IS RECORD (
   call_                         JSON_OBJECT_T,
   result_                       JSON_OBJECT_T,
   assign_                       VARCHAR2(4000),
   next_                         JSON_OBJECT_T
);

TYPE Executearray_Rec IS TABLE OF Execute_Rec;

TYPE Method_Rec IS RECORD (
   method_                       VARCHAR2(4000),
   args_                         JSON_OBJECT_T
);

TYPE AlertArgs_Rec IS RECORD (
   msg_                          VARCHAR2(4000)
);

TYPE ConfirmArgs_Rec IS RECORD (
   msg_                          VARCHAR2(4000)
);

TYPE InquireArgs_Rec IS RECORD (
   msg_                          VARCHAR2(4000)
);

TYPE LogArgs_Rec IS RECORD (
   msg_                          VARCHAR2(4000)
);

TYPE PrintDialogArgs_Rec IS RECORD (
   resultkey_                    VARCHAR2(4000)
);

TYPE ToastArgs_Rec IS RECORD (
   type_                         VARCHAR2(4000),
   msg_                          VARCHAR2(4000),
   title_                        VARCHAR2(4000)
);

TYPE StringifyArgs_Rec IS RECORD (
   source_                       VARCHAR2(4000),
   list_                         VARCHAR2(4000),
   value_                        VARCHAR2(4000),
   assign_                       VARCHAR2(4000)
);

TYPE SetArgs_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   original_                     BOOLEAN,
   value_                        VARCHAR2(4000)
);

TYPE BulkSetArgs_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   original_                     BOOLEAN,
   value_                        VARCHAR2(4000),
   attribute_                    VARCHAR2(4000)
);

TYPE ExitArgs_Rec IS RECORD (
   return_                       VARCHAR2(4000)
);

TYPE RefreshArgs_Rec IS RECORD (
   projection_                   VARCHAR2(4000)
);

TYPE IfArgs_Rec IS RECORD (
   expression_                   VARCHAR2(4000)
);

TYPE EveryArgs_Rec IS RECORD (
   expression_                   VARCHAR2(4000)
);

TYPE SomeArgs_Rec IS RECORD (
   expression_                   VARCHAR2(4000)
);

TYPE NavigateArgs_Rec IS RECORD (
   url_                          VARCHAR2(4000)
);

TYPE BulkNavigateArgs_Rec IS RECORD (
   url_                          VARCHAR2(4000)
);

TYPE DownloadArgs_Rec IS RECORD (
   url_                          VARCHAR2(4000)
);

TYPE UploadArgs_Rec IS RECORD (
   call_                         VARCHAR2(4000),
   url_                          VARCHAR2(4000),
   fileselector_                 VARCHAR2(4000)
);

TYPE PinArgs_Rec IS RECORD (
   keyref_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000)
);

TYPE BulkPinArgs_Rec IS RECORD (
   keyref_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000)
);

TYPE UnpinArgs_Rec IS RECORD (
   keyref_                       VARCHAR2(4000),
   datasource_                   VARCHAR2(4000)
);

TYPE SelectArgs_Rec IS RECORD (
   selection_                    VARCHAR2(4000),
   name_                         VARCHAR2(4000)
);

TYPE ActionArgs_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   projection_                   VARCHAR2(4000),
   bound_                        BOOLEAN,
   params_                       JSON_OBJECT_T
);

TYPE FunctionArgs_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   projection_                   VARCHAR2(4000),
   bound_                        BOOLEAN,
   assign_                       BOOLEAN
);

TYPE BulkActionArgs_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   projection_                   VARCHAR2(4000),
   bound_                        BOOLEAN,
   params_                       JSON_OBJECT_T
);

TYPE BulkFunctionArgs_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   projection_                   VARCHAR2(4000),
   bound_                        BOOLEAN
);

TYPE TransferArgs_Rec IS RECORD (
   params_array_                 JSON_ARRAY_T
);

TYPE ReceiveArgs_Rec IS RECORD (
   params_array_                 JSON_ARRAY_T
);

TYPE DialogArgs_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   input_                        JSON_OBJECT_T,
   output_                       JSON_OBJECT_T,
   projection_                   VARCHAR2(4000),
   client_                       VARCHAR2(4000)
);

TYPE AssistantArgs_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   input_                        JSON_OBJECT_T,
   output_                       JSON_OBJECT_T,
   projection_                   VARCHAR2(4000),
   client_                       VARCHAR2(4000)
);

TYPE PrintArgs_Rec IS RECORD (
   client_                       VARCHAR2(4000),
   page_                         VARCHAR2(4000),
   filters_                      JSON_ARRAY_T
);

TYPE PrintFilter_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   value_                        VARCHAR2(4000)
);

TYPE CommandGroup_Rec IS RECORD (
   type_                         VARCHAR2(4000),
   name_                         VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   commands_                     JSON_ARRAY_T,
   content_                      JSON_ARRAY_T
);

TYPE CommandButtonInput_Rec IS RECORD (
   visible_                      BOOLEAN,
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   disabled_                     BOOLEAN,
   background_color_             VARCHAR2(4000),
   color_                        VARCHAR2(4000),
   tooltip_                      VARCHAR2(4000)
);

TYPE Emphasis_Rec IS RECORD (
   emphasis_                     JSON_ARRAY_T
);

TYPE Attachments_Rec IS RECORD (
   enabled_                      VARCHAR2(4000)
);

TYPE Media_Rec IS RECORD (
   enabled_                      VARCHAR2(4000)
);

TYPE CrudActions_Rec IS RECORD (
   hooks_                        JSON_OBJECT_T,
   new_                          JSON_OBJECT_T,
   edit_                         JSON_OBJECT_T,
   delete_                       JSON_OBJECT_T,
   defaultcopy_                  JSON_OBJECT_T
);

TYPE CrudActionHooks_Rec IS RECORD (
   before_                       JSON_OBJECT_T,
   after_                        JSON_OBJECT_T,
   create_                       VARCHAR2(4000),
   update_                       VARCHAR2(4000),
   projection_                   VARCHAR2(4000)
);

TYPE CrudAction_Rec IS RECORD (
   enabled_                      VARCHAR2(4000),
   visible_                      VARCHAR2(4000)
);

TYPE Binding_Rec IS RECORD (
   bindname_                     VARCHAR2(4000),
   property_                     VARCHAR2(4000),
   schedule_                     VARCHAR2(4000)
);

TYPE Override_Rec IS RECORD (
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   collapsed_                    VARCHAR2(4000),
   visible_                      VARCHAR2(4000),
   preselect_                    VARCHAR2(4000),
   emphasis_                     JSON_ARRAY_T
);

TYPE Arrange_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   arrange_                      JSON_ARRAY_T
);

TYPE TabsElement_Rec IS RECORD (
   element_type_                 VARCHAR2(4000),
   is_reference_                 BOOLEAN,
   name_                         VARCHAR2(4000),
   tabs_                         JSON_ARRAY_T
);

TYPE Tab_Rec IS RECORD (
   name_                         VARCHAR2(4000),
   label_                        VARCHAR2(4000),
   translation_key_              VARCHAR2(4000),
   showlabel_                    BOOLEAN,
   visible_                      VARCHAR2(4000),
   content_                      JSON_ARRAY_T
);

------------------------------- MAIN METADATA -------------------------------

FUNCTION Build (
   rec_   IN Client_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Client_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('version', rec_.version_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.projection_ IS NULL) THEN
         json_.put('projection', JSON_OBJECT_T());
      ELSE
         json_.put('projection', rec_.projection_);
      END IF;
   END IF;
   IF (rec_.component_ IS NOT NULL) THEN
      json_.put('component', rec_.component_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.layout_ IS NULL) THEN
         json_.put('layout', JSON_OBJECT_T());
      ELSE
         json_.put('layout', rec_.layout_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Client_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Version (
   rec_   IN OUT NOCOPY Client_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.version_ := value_;
END Set_Version;
  

PROCEDURE Set_Projection (
   rec_   IN OUT NOCOPY Client_Rec,
   value_ IN            Projection_Rec )
IS
BEGIN
   rec_.projection_ := Build_Json___(value_);
END Set_Projection;

  
PROCEDURE Set_Component (
   rec_   IN OUT NOCOPY Client_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.component_ := value_;
END Set_Component;
  

PROCEDURE Set_Layout (
   rec_   IN OUT NOCOPY Client_Rec,
   value_ IN            Layout_Rec )
IS
BEGIN
   rec_.layout_ := Build_Json___(value_);
END Set_Layout;


FUNCTION Build (
   rec_   IN Projection_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Projection_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('service', rec_.service_);
   END IF;
   IF (TRUE) THEN
      json_.put('version', rec_.version_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.contains_ IS NULL) THEN
         json_.put('contains', JSON_OBJECT_T());
      ELSE
         json_.put('contains', rec_.contains_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.enumerations_ IS NULL) THEN
         json_.put('enumerations', JSON_OBJECT_T());
      ELSE
         json_.put('enumerations', rec_.enumerations_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.entities_ IS NULL) THEN
         json_.put('entities', JSON_OBJECT_T());
      ELSE
         json_.put('entities', rec_.entities_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.structures_ IS NULL) THEN
         json_.put('structures', JSON_OBJECT_T());
      ELSE
         json_.put('structures', rec_.structures_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.actions_ IS NULL) THEN
         json_.put('actions', JSON_OBJECT_T());
      ELSE
         json_.put('actions', rec_.actions_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.functions_ IS NULL) THEN
         json_.put('functions', JSON_OBJECT_T());
      ELSE
         json_.put('functions', rec_.functions_);
      END IF;
   END IF;
   IF (rec_.objectconnections_ IS NOT NULL) THEN
      IF (rec_.objectconnections_ IS NULL) THEN
         json_.put('objectconnections', JSON_OBJECT_T());
      ELSE
         json_.put('objectconnections', rec_.objectconnections_);
      END IF;
   END IF;
   IF (rec_.procedures_ IS NOT NULL) THEN
      IF (rec_.procedures_ IS NULL) THEN
         json_.put('procedures', JSON_OBJECT_T());
      ELSE
         json_.put('procedures', rec_.procedures_);
      END IF;
   END IF;
   IF (rec_.attachmentservices_ IS NOT NULL) THEN
      IF (rec_.attachmentservices_ IS NULL) THEN
         json_.put('attachmentservices', JSON_OBJECT_T());
      ELSE
         json_.put('attachmentservices', rec_.attachmentservices_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Projection_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Service (
   rec_   IN OUT NOCOPY Projection_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.service_ := value_;
END Set_Service;
  
PROCEDURE Set_Version (
   rec_   IN OUT NOCOPY Projection_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.version_ := value_;
END Set_Version;
  

PROCEDURE Add_Contains (
   rec_   IN OUT NOCOPY Projection_Rec,
   name_  IN            VARCHAR2,
   value_ IN            EntitySet_Rec )
IS
BEGIN
   IF (rec_.contains_ IS NULL) THEN
      rec_.contains_ := JSON_OBJECT_T();
   END IF;
   rec_.contains_.put(name_, Build_Json___(value_));
END Add_Contains;

  

PROCEDURE Add_Enumerations (
   rec_   IN OUT NOCOPY Projection_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Enumeration_Rec )
IS
BEGIN
   IF (rec_.enumerations_ IS NULL) THEN
      rec_.enumerations_ := JSON_OBJECT_T();
   END IF;
   rec_.enumerations_.put(name_, Build_Json___(value_));
END Add_Enumerations;

  

PROCEDURE Add_Entities (
   rec_   IN OUT NOCOPY Projection_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Entity_Rec )
IS
BEGIN
   IF (rec_.entities_ IS NULL) THEN
      rec_.entities_ := JSON_OBJECT_T();
   END IF;
   rec_.entities_.put(name_, Build_Json___(value_));
END Add_Entities;

  

PROCEDURE Add_Structures (
   rec_   IN OUT NOCOPY Projection_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Structure_Rec )
IS
BEGIN
   IF (rec_.structures_ IS NULL) THEN
      rec_.structures_ := JSON_OBJECT_T();
   END IF;
   rec_.structures_.put(name_, Build_Json___(value_));
END Add_Structures;

  

PROCEDURE Add_Actions (
   rec_   IN OUT NOCOPY Projection_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Action_Rec )
IS
BEGIN
   IF (rec_.actions_ IS NULL) THEN
      rec_.actions_ := JSON_OBJECT_T();
   END IF;
   rec_.actions_.put(name_, Build_Json___(value_));
END Add_Actions;

  

PROCEDURE Add_Functions (
   rec_   IN OUT NOCOPY Projection_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Function_Rec )
IS
BEGIN
   IF (rec_.functions_ IS NULL) THEN
      rec_.functions_ := JSON_OBJECT_T();
   END IF;
   rec_.functions_.put(name_, Build_Json___(value_));
END Add_Functions;

  

PROCEDURE Set_Objectconnections (
   rec_   IN OUT NOCOPY Projection_Rec,
   value_ IN            Procedure_Rec )
IS
BEGIN
   rec_.objectconnections_ := Build_Json___(value_);
END Set_Objectconnections;

  

PROCEDURE Add_Procedures (
   rec_   IN OUT NOCOPY Projection_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Procedure_Rec )
IS
BEGIN
   IF (rec_.procedures_ IS NULL) THEN
      rec_.procedures_ := JSON_OBJECT_T();
   END IF;
   rec_.procedures_.put(name_, Build_Json___(value_));
END Add_Procedures;

  

PROCEDURE Set_Attachmentservices (
   rec_   IN OUT NOCOPY Projection_Rec,
   value_ IN            Procedure_Rec )
IS
BEGIN
   rec_.attachmentservices_ := Build_Json___(value_);
END Set_Attachmentservices;


FUNCTION Build (
   rec_   IN EntitySet_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN EntitySet_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (TRUE) THEN
      json_.put('array', rec_.array_);
   END IF;
   IF (rec_.defaultfilter_ IS NOT NULL) THEN
      json_.put('defaultfilter', rec_.defaultfilter_);
   END IF;
   IF (rec_.contexts_ IS NOT NULL) THEN
      IF (rec_.contexts_ IS NULL) THEN
         json_.put('contexts', JSON_OBJECT_T());
      ELSE
         json_.put('contexts', rec_.contexts_);
      END IF;
   END IF;
   IF (rec_.offlinefilter_ IS NOT NULL) THEN
      IF (rec_.offlinefilter_ IS NULL) THEN
         json_.put('offlinefilter', JSON_OBJECT_T());
      ELSE
         json_.put('offlinefilter', rec_.offlinefilter_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY EntitySet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY EntitySet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Array (
   rec_   IN OUT NOCOPY EntitySet_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.array_ := value_;
END Set_Array;
  
PROCEDURE Set_Defaultfilter (
   rec_   IN OUT NOCOPY EntitySet_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.defaultfilter_ := value_;
END Set_Defaultfilter;
  

PROCEDURE Add_Contexts (
   rec_   IN OUT NOCOPY EntitySet_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.contexts_ IS NULL) THEN
      rec_.contexts_ := JSON_OBJECT_T();
   END IF;
   rec_.contexts_.put(name_, value_);
END Add_Contexts;

  

PROCEDURE Set_Offlinefilter (
   rec_   IN OUT NOCOPY EntitySet_Rec,
   value_ IN            FilterEvaluation_Rec )
IS
BEGIN
   rec_.offlinefilter_ := Build_Json___(value_);
END Set_Offlinefilter;


FUNCTION Build (
   rec_   IN Enumeration_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Enumeration_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.values_ IS NULL) THEN
         json_.put('values', JSON_ARRAY_T());
      ELSE
         json_.put('values', rec_.values_);
      END IF;
   END IF;
   IF (rec_.subsets_ IS NOT NULL) THEN
      IF (rec_.subsets_ IS NULL) THEN
         json_.put('subsets', JSON_OBJECT_T());
      ELSE
         json_.put('subsets', rec_.subsets_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.labels_ IS NULL) THEN
         json_.put('labels', JSON_ARRAY_T());
      ELSE
         json_.put('labels', rec_.labels_);
      END IF;
   END IF;
   IF (rec_.enum_prefix_ IS NOT NULL) THEN
      json_.put('enumPrefix', rec_.enum_prefix_);
   END IF;
   IF (rec_.lookup_encodings_ IS NOT NULL) THEN
      IF (rec_.lookup_encodings_ IS NULL) THEN
         json_.put('lookupEncodings', JSON_ARRAY_T());
      ELSE
         json_.put('lookupEncodings', rec_.lookup_encodings_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Enumeration_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Add_Values (
   rec_   IN OUT NOCOPY Enumeration_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.values_ IS NULL) THEN
      rec_.values_ := JSON_ARRAY_T();
   END IF;
   rec_.values_.append(value_);
END Add_Values;
  

PROCEDURE Add_Subsets (
   rec_   IN OUT NOCOPY Enumeration_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.subsets_ IS NULL) THEN
      rec_.subsets_ := JSON_OBJECT_T();
   END IF;
   rec_.subsets_.put(name_, value_);
END Add_Subsets;

  

PROCEDURE Add_Labels (
   rec_   IN OUT NOCOPY Enumeration_Rec,
   value_ IN            EnumLabel_Rec )
IS
BEGIN
   IF (rec_.labels_ IS NULL) THEN
      rec_.labels_ := JSON_ARRAY_T();
   END IF;
   rec_.labels_.append(Build_Json___(value_));
END Add_Labels;

  
PROCEDURE Set_Enum_Prefix (
   rec_   IN OUT NOCOPY Enumeration_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.enum_prefix_ := value_;
END Set_Enum_Prefix;
  

PROCEDURE Add_Lookup_Encodings (
   rec_   IN OUT NOCOPY Enumeration_Rec,
   value_ IN            LookupEncoding_Rec )
IS
BEGIN
   IF (rec_.lookup_encodings_ IS NULL) THEN
      rec_.lookup_encodings_ := JSON_ARRAY_T();
   END IF;
   rec_.lookup_encodings_.append(Build_Json___(value_));
END Add_Lookup_Encodings;


FUNCTION Build (
   rec_   IN EnumLabel_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN EnumLabel_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('value', rec_.value_);
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Value (
   rec_   IN OUT NOCOPY EnumLabel_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.value_ := value_;
END Set_Value;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY EnumLabel_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;

FUNCTION Build (
   rec_   IN LookupEncoding_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN LookupEncoding_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('val', rec_.val_);
   END IF;
   IF (TRUE) THEN
      json_.put('enc', rec_.enc_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Val (
   rec_   IN OUT NOCOPY LookupEncoding_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.val_ := value_;
END Set_Val;
  
PROCEDURE Set_Enc (
   rec_   IN OUT NOCOPY LookupEncoding_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.enc_ := value_;
END Set_Enc;

FUNCTION Build (
   rec_   IN Entity_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Entity_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('hasETag', rec_.has_e_tag_);
   END IF;
   IF (TRUE) THEN
      json_.put('hasKeys', rec_.has_keys_);
   END IF;
   IF (rec_.entitytype_ IS NOT NULL) THEN
      json_.put('entitytype', rec_.entitytype_);
   END IF;
   IF (rec_.c_r_u_d_ IS NOT NULL) THEN
      json_.put('CRUD', rec_.c_r_u_d_);
   END IF;
   IF (rec_.validateaction_ IS NOT NULL) THEN
      json_.put('validateaction', rec_.validateaction_);
   END IF;
   IF (rec_.luname_ IS NOT NULL) THEN
      json_.put('luname', rec_.luname_);
   END IF;
   IF (rec_.display_name_ IS NOT NULL) THEN
      json_.put('DisplayName', rec_.display_name_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.ludependencies_ IS NULL) THEN
         json_.put('ludependencies', JSON_ARRAY_T());
      ELSE
         json_.put('ludependencies', rec_.ludependencies_);
      END IF;
   END IF;
   IF (rec_.datavalidity_ IS NOT NULL) THEN
      IF (rec_.datavalidity_ IS NULL) THEN
         json_.put('datavalidity', JSON_OBJECT_T());
      ELSE
         json_.put('datavalidity', rec_.datavalidity_);
      END IF;
   END IF;
   IF (rec_.keys_ IS NOT NULL) THEN
      IF (rec_.keys_ IS NULL) THEN
         json_.put('keys', JSON_ARRAY_T());
      ELSE
         json_.put('keys', rec_.keys_);
      END IF;
   END IF;
   IF (rec_.syncpolicy_ IS NOT NULL) THEN
      IF (rec_.syncpolicy_ IS NULL) THEN
         json_.put('syncpolicy', JSON_OBJECT_T());
      ELSE
         json_.put('syncpolicy', rec_.syncpolicy_);
      END IF;
   END IF;
   IF (rec_.offline_query_ IS NOT NULL) THEN
      IF (rec_.offline_query_ IS NULL) THEN
         json_.put('offlineQuery', JSON_OBJECT_T());
      ELSE
         json_.put('offlineQuery', rec_.offline_query_);
      END IF;
   END IF;
   IF (rec_.contextmapping_ IS NOT NULL) THEN
      IF (rec_.contextmapping_ IS NULL) THEN
         json_.put('contextmapping', JSON_OBJECT_T());
      ELSE
         json_.put('contextmapping', rec_.contextmapping_);
      END IF;
   END IF;
   IF (rec_.contexttodefault_ IS NOT NULL) THEN
      IF (rec_.contexttodefault_ IS NULL) THEN
         json_.put('contexttodefault', JSON_OBJECT_T());
      ELSE
         json_.put('contexttodefault', rec_.contexttodefault_);
      END IF;
   END IF;
   IF (rec_.connected_entities_ IS NOT NULL) THEN
      IF (rec_.connected_entities_ IS NULL) THEN
         json_.put('ConnectedEntities', JSON_ARRAY_T());
      ELSE
         json_.put('ConnectedEntities', rec_.connected_entities_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.attributes_ IS NULL) THEN
         json_.put('attributes', JSON_OBJECT_T());
      ELSE
         json_.put('attributes', rec_.attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.references_ IS NULL) THEN
         json_.put('references', JSON_OBJECT_T());
      ELSE
         json_.put('references', rec_.references_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.arrays_ IS NULL) THEN
         json_.put('arrays', JSON_OBJECT_T());
      ELSE
         json_.put('arrays', rec_.arrays_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.actions_ IS NULL) THEN
         json_.put('actions', JSON_OBJECT_T());
      ELSE
         json_.put('actions', rec_.actions_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.functions_ IS NULL) THEN
         json_.put('functions', JSON_OBJECT_T());
      ELSE
         json_.put('functions', rec_.functions_);
      END IF;
   END IF;
   IF (rec_.transaction_group_ IS NOT NULL) THEN
      json_.put('transactionGroup', rec_.transaction_group_);
   END IF;
   IF (rec_.defaultcopyapplicable_ IS NOT NULL) THEN
      json_.put('defaultcopyapplicable', rec_.defaultcopyapplicable_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Has_E_Tag (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.has_e_tag_ := value_;
END Set_Has_E_Tag;
  
PROCEDURE Set_Has_Keys (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.has_keys_ := value_;
END Set_Has_Keys;
  
PROCEDURE Set_Entitytype (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entitytype_ := value_;
END Set_Entitytype;
  
PROCEDURE Set_C_R_U_D (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.c_r_u_d_ := value_;
END Set_C_R_U_D;
  
PROCEDURE Set_Validateaction (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.validateaction_ := value_;
END Set_Validateaction;
  
PROCEDURE Set_Luname (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.luname_ := value_;
END Set_Luname;
  
PROCEDURE Set_Display_Name (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.display_name_ := value_;
END Set_Display_Name;
  
PROCEDURE Add_Ludependencies (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.ludependencies_ IS NULL) THEN
      rec_.ludependencies_ := JSON_ARRAY_T();
   END IF;
   rec_.ludependencies_.append(value_);
END Add_Ludependencies;
  

PROCEDURE Set_Datavalidity (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            DataValidity_Rec )
IS
BEGIN
   rec_.datavalidity_ := Build_Json___(value_);
END Set_Datavalidity;

  
PROCEDURE Add_Keys (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.keys_ IS NULL) THEN
      rec_.keys_ := JSON_ARRAY_T();
   END IF;
   rec_.keys_.append(value_);
END Add_Keys;
  

PROCEDURE Set_Syncpolicy (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            Syncpolicy_Rec )
IS
BEGIN
   rec_.syncpolicy_ := Build_Json___(value_);
END Set_Syncpolicy;

  

PROCEDURE Set_Offline_Query (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            OfflineQuery_Rec )
IS
BEGIN
   rec_.offline_query_ := Build_Json___(value_);
END Set_Offline_Query;

  

PROCEDURE Add_Contextmapping (
   rec_   IN OUT NOCOPY Entity_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.contextmapping_ IS NULL) THEN
      rec_.contextmapping_ := JSON_OBJECT_T();
   END IF;
   rec_.contextmapping_.put(name_, value_);
END Add_Contextmapping;

  

PROCEDURE Add_Contexttodefault (
   rec_   IN OUT NOCOPY Entity_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.contexttodefault_ IS NULL) THEN
      rec_.contexttodefault_ := JSON_OBJECT_T();
   END IF;
   rec_.contexttodefault_.put(name_, value_);
END Add_Contexttodefault;

  
PROCEDURE Add_Connected_Entities (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.connected_entities_ IS NULL) THEN
      rec_.connected_entities_ := JSON_ARRAY_T();
   END IF;
   rec_.connected_entities_.append(value_);
END Add_Connected_Entities;
  

PROCEDURE Add_Attributes (
   rec_   IN OUT NOCOPY Entity_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Attribute_Rec )
IS
BEGIN
   IF (rec_.attributes_ IS NULL) THEN
      rec_.attributes_ := JSON_OBJECT_T();
   END IF;
   rec_.attributes_.put(name_, Build_Json___(value_));
END Add_Attributes;

  

PROCEDURE Add_References (
   rec_   IN OUT NOCOPY Entity_Rec,
   name_  IN            VARCHAR2,
   value_ IN            EntityReference_Rec )
IS
BEGIN
   IF (rec_.references_ IS NULL) THEN
      rec_.references_ := JSON_OBJECT_T();
   END IF;
   rec_.references_.put(name_, Build_Json___(value_));
END Add_References;

  

PROCEDURE Add_Arrays (
   rec_   IN OUT NOCOPY Entity_Rec,
   name_  IN            VARCHAR2,
   value_ IN            EntityReference_Rec )
IS
BEGIN
   IF (rec_.arrays_ IS NULL) THEN
      rec_.arrays_ := JSON_OBJECT_T();
   END IF;
   rec_.arrays_.put(name_, Build_Json___(value_));
END Add_Arrays;

  

PROCEDURE Add_Actions (
   rec_   IN OUT NOCOPY Entity_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Action_Rec )
IS
BEGIN
   IF (rec_.actions_ IS NULL) THEN
      rec_.actions_ := JSON_OBJECT_T();
   END IF;
   rec_.actions_.put(name_, Build_Json___(value_));
END Add_Actions;

  

PROCEDURE Add_Functions (
   rec_   IN OUT NOCOPY Entity_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Function_Rec )
IS
BEGIN
   IF (rec_.functions_ IS NULL) THEN
      rec_.functions_ := JSON_OBJECT_T();
   END IF;
   rec_.functions_.put(name_, Build_Json___(value_));
END Add_Functions;

  
PROCEDURE Set_Transaction_Group (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.transaction_group_ := value_;
END Set_Transaction_Group;
  
PROCEDURE Set_Defaultcopyapplicable (
   rec_   IN OUT NOCOPY Entity_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.defaultcopyapplicable_ := value_;
END Set_Defaultcopyapplicable;

FUNCTION Build (
   rec_   IN Structure_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Structure_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.attributes_ IS NULL) THEN
         json_.put('attributes', JSON_OBJECT_T());
      ELSE
         json_.put('attributes', rec_.attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.references_ IS NULL) THEN
         json_.put('references', JSON_OBJECT_T());
      ELSE
         json_.put('references', rec_.references_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.arrays_ IS NULL) THEN
         json_.put('arrays', JSON_OBJECT_T());
      ELSE
         json_.put('arrays', rec_.arrays_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Structure_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Attributes (
   rec_   IN OUT NOCOPY Structure_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Attribute_Rec )
IS
BEGIN
   IF (rec_.attributes_ IS NULL) THEN
      rec_.attributes_ := JSON_OBJECT_T();
   END IF;
   rec_.attributes_.put(name_, Build_Json___(value_));
END Add_Attributes;

  

PROCEDURE Add_References (
   rec_   IN OUT NOCOPY Structure_Rec,
   name_  IN            VARCHAR2,
   value_ IN            EntityReference_Rec )
IS
BEGIN
   IF (rec_.references_ IS NULL) THEN
      rec_.references_ := JSON_OBJECT_T();
   END IF;
   rec_.references_.put(name_, Build_Json___(value_));
END Add_References;

  

PROCEDURE Add_Arrays (
   rec_   IN OUT NOCOPY Structure_Rec,
   name_  IN            VARCHAR2,
   value_ IN            EntityReference_Rec )
IS
BEGIN
   IF (rec_.arrays_ IS NULL) THEN
      rec_.arrays_ := JSON_OBJECT_T();
   END IF;
   rec_.arrays_.put(name_, Build_Json___(value_));
END Add_Arrays;


FUNCTION Build (
   rec_   IN Attribute_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Attribute_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('datatype', rec_.datatype_);
   END IF;
   IF (rec_.size_ IS NOT NULL) THEN
      json_.put('size', rec_.size_);
   END IF;
   IF (rec_.scale_ IS NOT NULL) THEN
      json_.put('scale', rec_.scale_);
   END IF;
   IF (rec_.precision_ IS NOT NULL) THEN
      json_.put('precision', rec_.precision_);
   END IF;
   IF (rec_.subtype_ IS NOT NULL) THEN
      json_.put('subtype', rec_.subtype_);
   END IF;
   IF (rec_.format_ IS NOT NULL) THEN
      json_.put('format', rec_.format_);
   END IF;
   IF (rec_.regexp_ IS NOT NULL) THEN
      json_.put('regexp', rec_.regexp_);
   END IF;
   IF (rec_.array_ IS NOT NULL) THEN
      json_.put('array', rec_.array_);
   END IF;
   IF (rec_.keygeneration_ IS NOT NULL) THEN
      json_.put('keygeneration', rec_.keygeneration_);
   END IF;
   IF (rec_.validations_ IS NOT NULL) THEN
      IF (rec_.validations_ IS NULL) THEN
         json_.put('validations', JSON_ARRAY_T());
      ELSE
         json_.put('validations', rec_.validations_);
      END IF;
   END IF;
   IF (rec_.required_ IS NOT NULL) THEN
      IF (rec_.required_ = 'TRUE') THEN
         json_.put('required', TRUE);
      ELSIF (rec_.required_ = 'FALSE') THEN
         json_.put('required', FALSE);
      ELSE
         json_.put('required', rec_.required_);
      END IF;
   END IF;
   IF (rec_.editable_ IS NOT NULL) THEN
      IF (rec_.editable_ = 'TRUE') THEN
         json_.put('editable', TRUE);
      ELSIF (rec_.editable_ = 'FALSE') THEN
         json_.put('editable', FALSE);
      ELSE
         json_.put('editable', rec_.editable_);
      END IF;
   END IF;
   IF (rec_.updatable_ IS NOT NULL) THEN
      IF (rec_.updatable_ = 'TRUE') THEN
         json_.put('updatable', TRUE);
      ELSIF (rec_.updatable_ = 'FALSE') THEN
         json_.put('updatable', FALSE);
      ELSE
         json_.put('updatable', rec_.updatable_);
      END IF;
   END IF;
   IF (rec_.insertable_ IS NOT NULL) THEN
      IF (rec_.insertable_ = 'TRUE') THEN
         json_.put('insertable', TRUE);
      ELSIF (rec_.insertable_ = 'FALSE') THEN
         json_.put('insertable', FALSE);
      ELSE
         json_.put('insertable', rec_.insertable_);
      END IF;
   END IF;
   IF (rec_.unbound_ IS NOT NULL) THEN
      IF (rec_.unbound_ = 'TRUE') THEN
         json_.put('unbound', TRUE);
      ELSIF (rec_.unbound_ = 'FALSE') THEN
         json_.put('unbound', FALSE);
      ELSE
         json_.put('unbound', rec_.unbound_);
      END IF;
   END IF;
   IF (rec_.multiselect_ IS NOT NULL) THEN
      IF (rec_.multiselect_ = 'TRUE') THEN
         json_.put('multiselect', TRUE);
      ELSIF (rec_.multiselect_ = 'FALSE') THEN
         json_.put('multiselect', FALSE);
      ELSE
         json_.put('multiselect', rec_.multiselect_);
      END IF;
   END IF;
   IF (rec_.from_entity_ IS NOT NULL) THEN
      json_.put('FromEntity', rec_.from_entity_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Datatype (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datatype_ := value_;
END Set_Datatype;
  

PROCEDURE Set_Size (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            INTEGER )
IS
BEGIN
   rec_.size_ := value_;
END Set_Size;

  

PROCEDURE Set_Scale (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            INTEGER )
IS
BEGIN
   rec_.scale_ := value_;
END Set_Scale;

  

PROCEDURE Set_Precision (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            INTEGER )
IS
BEGIN
   rec_.precision_ := value_;
END Set_Precision;

  
PROCEDURE Set_Subtype (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.subtype_ := value_;
END Set_Subtype;
  
PROCEDURE Set_Format (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.format_ := value_;
END Set_Format;
  
PROCEDURE Set_Regexp (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.regexp_ := value_;
END Set_Regexp;
  
PROCEDURE Set_Array (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.array_ := value_;
END Set_Array;
  
PROCEDURE Set_Keygeneration (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.keygeneration_ := value_;
END Set_Keygeneration;
  

PROCEDURE Add_Validations (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            Validation_Rec )
IS
BEGIN
   IF (rec_.validations_ IS NULL) THEN
      rec_.validations_ := JSON_ARRAY_T();
   END IF;
   rec_.validations_.append(Build_Json___(value_));
END Add_Validations;

  
PROCEDURE Set_Required (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.required_ := value_;
END Set_Required;


PROCEDURE Set_Required (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.required_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Required;
  
PROCEDURE Set_Editable (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.editable_ := value_;
END Set_Editable;


PROCEDURE Set_Editable (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.editable_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Editable;
  
PROCEDURE Set_Updatable (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.updatable_ := value_;
END Set_Updatable;


PROCEDURE Set_Updatable (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.updatable_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Updatable;
  
PROCEDURE Set_Insertable (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.insertable_ := value_;
END Set_Insertable;


PROCEDURE Set_Insertable (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.insertable_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Insertable;
  
PROCEDURE Set_Unbound (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.unbound_ := value_;
END Set_Unbound;


PROCEDURE Set_Unbound (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.unbound_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Unbound;
  
PROCEDURE Set_Multiselect (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.multiselect_ := value_;
END Set_Multiselect;


PROCEDURE Set_Multiselect (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.multiselect_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Multiselect;
  
PROCEDURE Set_From_Entity (
   rec_   IN OUT NOCOPY Attribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.from_entity_ := value_;
END Set_From_Entity;

FUNCTION Build (
   rec_   IN Validation_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Validation_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('expression', rec_.expression_);
   END IF;
   IF (TRUE) THEN
      json_.put('message', rec_.message_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Expression (
   rec_   IN OUT NOCOPY Validation_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.expression_ := value_;
END Set_Expression;
  
PROCEDURE Set_Message (
   rec_   IN OUT NOCOPY Validation_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.message_ := value_;
END Set_Message;

FUNCTION Build (
   rec_   IN EntityReference_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN EntityReference_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('target', rec_.target_);
   END IF;
   IF (TRUE) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.case_ IS NOT NULL) THEN
      IF (rec_.case_ = 'TRUE') THEN
         json_.put('case', TRUE);
      ELSIF (rec_.case_ = 'FALSE') THEN
         json_.put('case', FALSE);
      ELSE
         json_.put('case', rec_.case_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.mapping_ IS NULL) THEN
         json_.put('mapping', JSON_OBJECT_T());
      ELSE
         json_.put('mapping', rec_.mapping_);
      END IF;
   END IF;
   IF (rec_.contexts_ IS NOT NULL) THEN
      IF (rec_.contexts_ IS NULL) THEN
         json_.put('contexts', JSON_OBJECT_T());
      ELSE
         json_.put('contexts', rec_.contexts_);
      END IF;
   END IF;
   IF (rec_.prefetch_ IS NOT NULL) THEN
      IF (rec_.prefetch_ IS NULL) THEN
         json_.put('prefetch', JSON_OBJECT_T());
      ELSE
         json_.put('prefetch', rec_.prefetch_);
      END IF;
   END IF;
   IF (rec_.copy_ IS NOT NULL) THEN
      IF (rec_.copy_ IS NULL) THEN
         json_.put('copy', JSON_OBJECT_T());
      ELSE
         json_.put('copy', rec_.copy_);
      END IF;
   END IF;
   IF (rec_.existcheck_ IS NOT NULL) THEN
      json_.put('existcheck', rec_.existcheck_);
   END IF;
   IF (rec_.wildcard_ IS NOT NULL) THEN
      json_.put('wildcard', rec_.wildcard_);
   END IF;
   IF (rec_.offlinefilter_ IS NOT NULL) THEN
      IF (rec_.offlinefilter_ IS NULL) THEN
         json_.put('offlinefilter', JSON_OBJECT_T());
      ELSE
         json_.put('offlinefilter', rec_.offlinefilter_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Target (
   rec_   IN OUT NOCOPY EntityReference_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.target_ := value_;
END Set_Target;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY EntityReference_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Set_Case (
   rec_   IN OUT NOCOPY EntityReference_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.case_ := value_;
END Set_Case;


PROCEDURE Set_Case (
   rec_   IN OUT NOCOPY EntityReference_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.case_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Case;
  

PROCEDURE Add_Mapping (
   rec_   IN OUT NOCOPY EntityReference_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.mapping_ IS NULL) THEN
      rec_.mapping_ := JSON_OBJECT_T();
   END IF;
   rec_.mapping_.put(name_, value_);
END Add_Mapping;

  

PROCEDURE Add_Contexts (
   rec_   IN OUT NOCOPY EntityReference_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.contexts_ IS NULL) THEN
      rec_.contexts_ := JSON_OBJECT_T();
   END IF;
   rec_.contexts_.put(name_, value_);
END Add_Contexts;

  

PROCEDURE Add_Prefetch (
   rec_   IN OUT NOCOPY EntityReference_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.prefetch_ IS NULL) THEN
      rec_.prefetch_ := JSON_OBJECT_T();
   END IF;
   rec_.prefetch_.put(name_, value_);
END Add_Prefetch;

  

PROCEDURE Add_Copy (
   rec_   IN OUT NOCOPY EntityReference_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.copy_ IS NULL) THEN
      rec_.copy_ := JSON_OBJECT_T();
   END IF;
   rec_.copy_.put(name_, value_);
END Add_Copy;

  
PROCEDURE Set_Existcheck (
   rec_   IN OUT NOCOPY EntityReference_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.existcheck_ := value_;
END Set_Existcheck;
  
PROCEDURE Set_Wildcard (
   rec_   IN OUT NOCOPY EntityReference_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.wildcard_ := value_;
END Set_Wildcard;
  

PROCEDURE Set_Offlinefilter (
   rec_   IN OUT NOCOPY EntityReference_Rec,
   value_ IN            FilterEvaluation_Rec )
IS
BEGIN
   rec_.offlinefilter_ := Build_Json___(value_);
END Set_Offlinefilter;


FUNCTION Build (
   rec_   IN Action_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Action_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.ludependencies_ IS NULL) THEN
         json_.put('ludependencies', JSON_ARRAY_T());
      ELSE
         json_.put('ludependencies', rec_.ludependencies_);
      END IF;
   END IF;
   IF (rec_.transaction_group_ IS NOT NULL) THEN
      json_.put('transactionGroup', rec_.transaction_group_);
   END IF;
   IF (rec_.syncpolicy_ IS NOT NULL) THEN
      IF (rec_.syncpolicy_ IS NULL) THEN
         json_.put('syncpolicy', JSON_OBJECT_T());
      ELSE
         json_.put('syncpolicy', rec_.syncpolicy_);
      END IF;
   END IF;
   IF (rec_.return_type_ IS NOT NULL) THEN
      IF (rec_.return_type_ IS NULL) THEN
         json_.put('returnType', JSON_OBJECT_T());
      ELSE
         json_.put('returnType', rec_.return_type_);
      END IF;
   END IF;
   IF (rec_.modifies_ IS NOT NULL) THEN
      IF (rec_.modifies_ IS NULL) THEN
         json_.put('modifies', JSON_OBJECT_T());
      ELSE
         json_.put('modifies', rec_.modifies_);
      END IF;
   END IF;
   IF (rec_.parameters_ IS NOT NULL) THEN
      IF (rec_.parameters_ IS NULL) THEN
         json_.put('parameters', JSON_ARRAY_T());
      ELSE
         json_.put('parameters', rec_.parameters_);
      END IF;
   END IF;
   IF (rec_.state_transition_ IS NOT NULL) THEN
      json_.put('StateTransition', rec_.state_transition_);
   END IF;
   IF (rec_.checkpoint_ IS NOT NULL) THEN
      json_.put('Checkpoint', rec_.checkpoint_);
   END IF;
   IF (rec_.legacy_checkpoints_ IS NOT NULL) THEN
      IF (rec_.legacy_checkpoints_ IS NULL) THEN
         json_.put('LegacyCheckpoints', JSON_ARRAY_T());
      ELSE
         json_.put('LegacyCheckpoints', rec_.legacy_checkpoints_);
      END IF;
   END IF;
   IF (rec_.checkpoints_active_ IS NOT NULL) THEN
      IF (rec_.checkpoints_active_ = 'TRUE') THEN
         json_.put('CheckpointsActive', TRUE);
      ELSIF (rec_.checkpoints_active_ = 'FALSE') THEN
         json_.put('CheckpointsActive', FALSE);
      ELSE
         json_.put('CheckpointsActive', rec_.checkpoints_active_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Add_Ludependencies (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.ludependencies_ IS NULL) THEN
      rec_.ludependencies_ := JSON_ARRAY_T();
   END IF;
   rec_.ludependencies_.append(value_);
END Add_Ludependencies;
  
PROCEDURE Set_Transaction_Group (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.transaction_group_ := value_;
END Set_Transaction_Group;
  

PROCEDURE Set_Syncpolicy (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            OfflineSyncpolicy_Rec )
IS
BEGIN
   rec_.syncpolicy_ := Build_Json___(value_);
END Set_Syncpolicy;

  

PROCEDURE Set_Return_Type (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            MethodReturnType_Rec )
IS
BEGIN
   rec_.return_type_ := Build_Json___(value_);
END Set_Return_Type;

  

PROCEDURE Add_Modifies (
   rec_   IN OUT NOCOPY Action_Rec,
   name_  IN            VARCHAR2,
   value_ IN            ModifiesValues_Rec )
IS
BEGIN
   IF (rec_.modifies_ IS NULL) THEN
      rec_.modifies_ := JSON_OBJECT_T();
   END IF;
   rec_.modifies_.put(name_, Build_Json___(value_));
END Add_Modifies;

  

PROCEDURE Add_Parameters (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            Parameter_Rec )
IS
BEGIN
   IF (rec_.parameters_ IS NULL) THEN
      rec_.parameters_ := JSON_ARRAY_T();
   END IF;
   rec_.parameters_.append(Build_Json___(value_));
END Add_Parameters;

  
PROCEDURE Set_State_Transition (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.state_transition_ := value_;
END Set_State_Transition;
  
PROCEDURE Set_Checkpoint (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.checkpoint_ := value_;
END Set_Checkpoint;
  
PROCEDURE Add_Legacy_Checkpoints (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.legacy_checkpoints_ IS NULL) THEN
      rec_.legacy_checkpoints_ := JSON_ARRAY_T();
   END IF;
   rec_.legacy_checkpoints_.append(value_);
END Add_Legacy_Checkpoints;
  
PROCEDURE Set_Checkpoints_Active (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.checkpoints_active_ := value_;
END Set_Checkpoints_Active;


PROCEDURE Set_Checkpoints_Active (
   rec_   IN OUT NOCOPY Action_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.checkpoints_active_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Checkpoints_Active;

FUNCTION Build (
   rec_   IN ModifiesValues_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ModifiesValues_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('expression', rec_.expression_);
   END IF;
   IF (TRUE) THEN
      json_.put('invalidates', rec_.invalidates_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Expression (
   rec_   IN OUT NOCOPY ModifiesValues_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.expression_ := value_;
END Set_Expression;
  
PROCEDURE Set_Invalidates (
   rec_   IN OUT NOCOPY ModifiesValues_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.invalidates_ := value_;
END Set_Invalidates;

FUNCTION Build (
   rec_   IN Parameter_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Parameter_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('DataType', rec_.data_type_);
   END IF;
   IF (rec_.sub_type_ IS NOT NULL) THEN
      json_.put('SubType', rec_.sub_type_);
   END IF;
   IF (rec_.true_value_ IS NOT NULL) THEN
      json_.put('TrueValue', rec_.true_value_);
   END IF;
   IF (rec_.false_value_ IS NOT NULL) THEN
      json_.put('FalseValue', rec_.false_value_);
   END IF;
   IF (rec_.scale_ IS NOT NULL) THEN
      json_.put('Scale', rec_.scale_);
   END IF;
   IF (rec_.precision_ IS NOT NULL) THEN
      json_.put('Precision', rec_.precision_);
   END IF;
   IF (TRUE) THEN
      json_.put('Collection', rec_.collection_);
   END IF;
   IF (TRUE) THEN
      json_.put('Nullable', rec_.nullable_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Data_Type (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.data_type_ := value_;
END Set_Data_Type;
  
PROCEDURE Set_Sub_Type (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.sub_type_ := value_;
END Set_Sub_Type;
  
PROCEDURE Set_True_Value (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.true_value_ := value_;
END Set_True_Value;
  
PROCEDURE Set_False_Value (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.false_value_ := value_;
END Set_False_Value;
  
PROCEDURE Set_Scale (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.scale_ := value_;
END Set_Scale;
  
PROCEDURE Set_Precision (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.precision_ := value_;
END Set_Precision;
  
PROCEDURE Set_Collection (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collection_ := value_;
END Set_Collection;
  
PROCEDURE Set_Nullable (
   rec_   IN OUT NOCOPY Parameter_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.nullable_ := value_;
END Set_Nullable;

FUNCTION Build (
   rec_   IN Function_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Function_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.name_ IS NOT NULL) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.ludependencies_ IS NULL) THEN
         json_.put('ludependencies', JSON_ARRAY_T());
      ELSE
         json_.put('ludependencies', rec_.ludependencies_);
      END IF;
   END IF;
   IF (rec_.alterattributes_ IS NOT NULL) THEN
      IF (rec_.alterattributes_ IS NULL) THEN
         json_.put('alterattributes', JSON_ARRAY_T());
      ELSE
         json_.put('alterattributes', rec_.alterattributes_);
      END IF;
   END IF;
   IF (rec_.syncpolicy_ IS NOT NULL) THEN
      IF (rec_.syncpolicy_ IS NULL) THEN
         json_.put('syncpolicy', JSON_OBJECT_T());
      ELSE
         json_.put('syncpolicy', rec_.syncpolicy_);
      END IF;
   END IF;
   IF (rec_.return_type_ IS NOT NULL) THEN
      IF (rec_.return_type_ IS NULL) THEN
         json_.put('returnType', JSON_OBJECT_T());
      ELSE
         json_.put('returnType', rec_.return_type_);
      END IF;
   END IF;
   IF (rec_.parameters_ IS NOT NULL) THEN
      IF (rec_.parameters_ IS NULL) THEN
         json_.put('parameters', JSON_ARRAY_T());
      ELSE
         json_.put('parameters', rec_.parameters_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Add_Ludependencies (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.ludependencies_ IS NULL) THEN
      rec_.ludependencies_ := JSON_ARRAY_T();
   END IF;
   rec_.ludependencies_.append(value_);
END Add_Ludependencies;
  
PROCEDURE Add_Alterattributes (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.alterattributes_ IS NULL) THEN
      rec_.alterattributes_ := JSON_ARRAY_T();
   END IF;
   rec_.alterattributes_.append(value_);
END Add_Alterattributes;
  

PROCEDURE Set_Syncpolicy (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            OfflineSyncpolicy_Rec )
IS
BEGIN
   rec_.syncpolicy_ := Build_Json___(value_);
END Set_Syncpolicy;

  

PROCEDURE Set_Return_Type (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            MethodReturnType_Rec )
IS
BEGIN
   rec_.return_type_ := Build_Json___(value_);
END Set_Return_Type;

  

PROCEDURE Add_Parameters (
   rec_   IN OUT NOCOPY Function_Rec,
   value_ IN            Parameter_Rec )
IS
BEGIN
   IF (rec_.parameters_ IS NULL) THEN
      rec_.parameters_ := JSON_ARRAY_T();
   END IF;
   rec_.parameters_.append(Build_Json___(value_));
END Add_Parameters;


FUNCTION Build (
   rec_   IN MethodReturnType_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN MethodReturnType_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('dataType', rec_.data_type_);
   END IF;
   IF (rec_.sub_type_ IS NOT NULL) THEN
      json_.put('subType', rec_.sub_type_);
   END IF;
   IF (rec_.true_value_ IS NOT NULL) THEN
      json_.put('trueValue', rec_.true_value_);
   END IF;
   IF (rec_.false_value_ IS NOT NULL) THEN
      json_.put('falseValue', rec_.false_value_);
   END IF;
   IF (TRUE) THEN
      json_.put('collection', rec_.collection_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Data_Type (
   rec_   IN OUT NOCOPY MethodReturnType_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.data_type_ := value_;
END Set_Data_Type;
  
PROCEDURE Set_Sub_Type (
   rec_   IN OUT NOCOPY MethodReturnType_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.sub_type_ := value_;
END Set_Sub_Type;
  
PROCEDURE Set_True_Value (
   rec_   IN OUT NOCOPY MethodReturnType_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.true_value_ := value_;
END Set_True_Value;
  
PROCEDURE Set_False_Value (
   rec_   IN OUT NOCOPY MethodReturnType_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.false_value_ := value_;
END Set_False_Value;
  
PROCEDURE Set_Collection (
   rec_   IN OUT NOCOPY MethodReturnType_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collection_ := value_;
END Set_Collection;

FUNCTION Build (
   rec_   IN DataValidity_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DataValidity_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('type', rec_.type_);
   END IF;
   IF (rec_.validfromcolumn_ IS NOT NULL) THEN
      json_.put('validfromcolumn', rec_.validfromcolumn_);
   END IF;
   IF (rec_.validtocolumn_ IS NOT NULL) THEN
      json_.put('validtocolumn', rec_.validtocolumn_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Type (
   rec_   IN OUT NOCOPY DataValidity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.type_ := value_;
END Set_Type;
  
PROCEDURE Set_Validfromcolumn (
   rec_   IN OUT NOCOPY DataValidity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.validfromcolumn_ := value_;
END Set_Validfromcolumn;
  
PROCEDURE Set_Validtocolumn (
   rec_   IN OUT NOCOPY DataValidity_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.validtocolumn_ := value_;
END Set_Validtocolumn;

FUNCTION Build (
   rec_   IN FilterEvaluation_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN FilterEvaluation_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.dummy_ IS NOT NULL) THEN
      json_.put('dummy', rec_.dummy_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Dummy (
   rec_   IN OUT NOCOPY FilterEvaluation_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.dummy_ := value_;
END Set_Dummy;

FUNCTION Build (
   rec_   IN OfflineSyncpolicy_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN OfflineSyncpolicy_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('type', rec_.type_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Type (
   rec_   IN OUT NOCOPY OfflineSyncpolicy_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.type_ := value_;
END Set_Type;

FUNCTION Build (
   rec_   IN Syncpolicy_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Syncpolicy_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('type', rec_.type_);
   END IF;
   IF (rec_.default_schedule_ IS NOT NULL) THEN
      IF (rec_.default_schedule_ IS NULL) THEN
         json_.put('defaultSchedule', JSON_OBJECT_T());
      ELSE
         json_.put('defaultSchedule', rec_.default_schedule_);
      END IF;
   END IF;
   IF (rec_.cache_invalidation_ IS NOT NULL) THEN
      IF (rec_.cache_invalidation_ IS NULL) THEN
         json_.put('cacheInvalidation', JSON_OBJECT_T());
      ELSE
         json_.put('cacheInvalidation', rec_.cache_invalidation_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Type (
   rec_   IN OUT NOCOPY Syncpolicy_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.type_ := value_;
END Set_Type;
  

PROCEDURE Set_Default_Schedule (
   rec_   IN OUT NOCOPY Syncpolicy_Rec,
   value_ IN            SyncSchedule_Rec )
IS
BEGIN
   rec_.default_schedule_ := Build_Json___(value_);
END Set_Default_Schedule;

  

PROCEDURE Set_Cache_Invalidation (
   rec_   IN OUT NOCOPY Syncpolicy_Rec,
   value_ IN            SyncCacheInvalidation_Rec )
IS
BEGIN
   rec_.cache_invalidation_ := Build_Json___(value_);
END Set_Cache_Invalidation;


FUNCTION Build (
   rec_   IN SyncSchedule_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN SyncSchedule_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('interval', rec_.interval_);
   END IF;
   IF (rec_.time_ IS NOT NULL) THEN
      json_.put('time', rec_.time_);
   END IF;
   IF (rec_.days_ IS NOT NULL) THEN
      IF (rec_.days_ IS NULL) THEN
         json_.put('days', JSON_ARRAY_T());
      ELSE
         json_.put('days', rec_.days_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Interval (
   rec_   IN OUT NOCOPY SyncSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.interval_ := value_;
END Set_Interval;
  
PROCEDURE Set_Time (
   rec_   IN OUT NOCOPY SyncSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.time_ := value_;
END Set_Time;
  
PROCEDURE Add_Days (
   rec_   IN OUT NOCOPY SyncSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.days_ IS NULL) THEN
      rec_.days_ := JSON_ARRAY_T();
   END IF;
   rec_.days_.append(value_);
END Add_Days;

FUNCTION Build (
   rec_   IN SyncCacheInvalidation_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN SyncCacheInvalidation_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('interval', rec_.interval_);
   END IF;
   IF (rec_.time_ IS NOT NULL) THEN
      json_.put('time', rec_.time_);
   END IF;
   IF (rec_.period_ IS NOT NULL) THEN
      json_.put('period', rec_.period_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Interval (
   rec_   IN OUT NOCOPY SyncCacheInvalidation_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.interval_ := value_;
END Set_Interval;
  

PROCEDURE Set_Time (
   rec_   IN OUT NOCOPY SyncCacheInvalidation_Rec,
   value_ IN            INTEGER )
IS
BEGIN
   rec_.time_ := value_;
END Set_Time;

  
PROCEDURE Set_Period (
   rec_   IN OUT NOCOPY SyncCacheInvalidation_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.period_ := value_;
END Set_Period;

FUNCTION Build (
   rec_   IN Procedure_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Procedure_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('type', rec_.type_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.params_ IS NULL) THEN
         json_.put('params', JSON_ARRAY_T());
      ELSE
         json_.put('params', rec_.params_);
      END IF;
   END IF;
   IF (rec_.layers_ IS NOT NULL) THEN
      IF (rec_.layers_ IS NULL) THEN
         json_.put('layers', JSON_ARRAY_T());
      ELSE
         json_.put('layers', rec_.layers_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Procedure_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Type (
   rec_   IN OUT NOCOPY Procedure_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.type_ := value_;
END Set_Type;
  

PROCEDURE Add_Params (
   rec_   IN OUT NOCOPY Procedure_Rec,
   value_ IN            ProcedureParameter_Rec )
IS
BEGIN
   IF (rec_.params_ IS NULL) THEN
      rec_.params_ := JSON_ARRAY_T();
   END IF;
   rec_.params_.append(Build_Json___(value_));
END Add_Params;

  

PROCEDURE Add_Layers (
   rec_   IN OUT NOCOPY Procedure_Rec,
   value_ IN            ProcedureLayer_Rec )
IS
BEGIN
   IF (rec_.layers_ IS NULL) THEN
      rec_.layers_ := JSON_ARRAY_T();
   END IF;
   rec_.layers_.append(Build_Json___(value_));
END Add_Layers;


FUNCTION Build (
   rec_   IN ProcedureParameter_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ProcedureParameter_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('datatype', rec_.datatype_);
   END IF;
   IF (rec_.subtype_ IS NOT NULL) THEN
      json_.put('subtype', rec_.subtype_);
   END IF;
   IF (rec_.true_value_ IS NOT NULL) THEN
      json_.put('trueValue', rec_.true_value_);
   END IF;
   IF (rec_.false_value_ IS NOT NULL) THEN
      json_.put('falseValue', rec_.false_value_);
   END IF;
   IF (rec_.scale_ IS NOT NULL) THEN
      json_.put('scale', rec_.scale_);
   END IF;
   IF (rec_.precision_ IS NOT NULL) THEN
      json_.put('precision', rec_.precision_);
   END IF;
   IF (TRUE) THEN
      json_.put('collection', rec_.collection_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY ProcedureParameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Datatype (
   rec_   IN OUT NOCOPY ProcedureParameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datatype_ := value_;
END Set_Datatype;
  
PROCEDURE Set_Subtype (
   rec_   IN OUT NOCOPY ProcedureParameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.subtype_ := value_;
END Set_Subtype;
  
PROCEDURE Set_True_Value (
   rec_   IN OUT NOCOPY ProcedureParameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.true_value_ := value_;
END Set_True_Value;
  
PROCEDURE Set_False_Value (
   rec_   IN OUT NOCOPY ProcedureParameter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.false_value_ := value_;
END Set_False_Value;
  

PROCEDURE Set_Scale (
   rec_   IN OUT NOCOPY ProcedureParameter_Rec,
   value_ IN            INTEGER )
IS
BEGIN
   rec_.scale_ := value_;
END Set_Scale;

  

PROCEDURE Set_Precision (
   rec_   IN OUT NOCOPY ProcedureParameter_Rec,
   value_ IN            INTEGER )
IS
BEGIN
   rec_.precision_ := value_;
END Set_Precision;

  
PROCEDURE Set_Collection (
   rec_   IN OUT NOCOPY ProcedureParameter_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collection_ := value_;
END Set_Collection;

FUNCTION Build (
   rec_   IN ProcedureLayer_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ProcedureLayer_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.vars_ IS NOT NULL) THEN
      IF (rec_.vars_ IS NULL) THEN
         json_.put('vars', JSON_ARRAY_T());
      ELSE
         json_.put('vars', rec_.vars_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.execute_ IS NULL) THEN
         json_.put('execute', JSON_ARRAY_T());
      ELSE
         json_.put('execute', rec_.execute_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Add_Vars (
   rec_   IN OUT NOCOPY ProcedureLayer_Rec,
   value_ IN            ProcedureVariable_Rec )
IS
BEGIN
   IF (rec_.vars_ IS NULL) THEN
      rec_.vars_ := JSON_ARRAY_T();
   END IF;
   rec_.vars_.append(Build_Json___(value_));
END Add_Vars;

  

PROCEDURE Add_Execute (
   rec_   IN OUT NOCOPY ProcedureLayer_Rec,
   value_ IN            ProcedureExecution_Rec )
IS
BEGIN
   IF (rec_.execute_ IS NULL) THEN
      rec_.execute_ := JSON_ARRAY_T();
   END IF;
   rec_.execute_.append(Build_Json___(value_));
END Add_Execute;


FUNCTION Build (
   rec_   IN ProcedureVariable_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ProcedureVariable_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('dataType', rec_.data_type_);
   END IF;
   IF (rec_.sub_type_ IS NOT NULL) THEN
      json_.put('subType', rec_.sub_type_);
   END IF;
   IF (rec_.true_value_ IS NOT NULL) THEN
      json_.put('trueValue', rec_.true_value_);
   END IF;
   IF (rec_.false_value_ IS NOT NULL) THEN
      json_.put('falseValue', rec_.false_value_);
   END IF;
   IF (rec_.scale_ IS NOT NULL) THEN
      json_.put('scale', rec_.scale_);
   END IF;
   IF (rec_.precision_ IS NOT NULL) THEN
      json_.put('precision', rec_.precision_);
   END IF;
   IF (TRUE) THEN
      json_.put('collection', rec_.collection_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY ProcedureVariable_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Data_Type (
   rec_   IN OUT NOCOPY ProcedureVariable_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.data_type_ := value_;
END Set_Data_Type;
  
PROCEDURE Set_Sub_Type (
   rec_   IN OUT NOCOPY ProcedureVariable_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.sub_type_ := value_;
END Set_Sub_Type;
  
PROCEDURE Set_True_Value (
   rec_   IN OUT NOCOPY ProcedureVariable_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.true_value_ := value_;
END Set_True_Value;
  
PROCEDURE Set_False_Value (
   rec_   IN OUT NOCOPY ProcedureVariable_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.false_value_ := value_;
END Set_False_Value;
  

PROCEDURE Set_Scale (
   rec_   IN OUT NOCOPY ProcedureVariable_Rec,
   value_ IN            INTEGER )
IS
BEGIN
   rec_.scale_ := value_;
END Set_Scale;

  

PROCEDURE Set_Precision (
   rec_   IN OUT NOCOPY ProcedureVariable_Rec,
   value_ IN            INTEGER )
IS
BEGIN
   rec_.precision_ := value_;
END Set_Precision;

  
PROCEDURE Set_Collection (
   rec_   IN OUT NOCOPY ProcedureVariable_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collection_ := value_;
END Set_Collection;

FUNCTION Build (
   rec_   IN ProcedureExecution_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ProcedureExecution_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.dummy_ IS NOT NULL) THEN
      json_.put('dummy', rec_.dummy_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Dummy (
   rec_   IN OUT NOCOPY ProcedureExecution_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.dummy_ := value_;
END Set_Dummy;

FUNCTION Build (
   rec_   IN OfflineQuery_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN OfflineQuery_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.from_ IS NULL) THEN
         json_.put('from', JSON_OBJECT_T());
      ELSE
         json_.put('from', rec_.from_);
      END IF;
   END IF;
   IF (rec_.joins_ IS NOT NULL) THEN
      IF (rec_.joins_ IS NULL) THEN
         json_.put('joins', JSON_ARRAY_T());
      ELSE
         json_.put('joins', rec_.joins_);
      END IF;
   END IF;
   IF (rec_.where_ IS NOT NULL) THEN
      IF (rec_.where_ IS NULL) THEN
         json_.put('where', JSON_OBJECT_T());
      ELSE
         json_.put('where', rec_.where_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.select_ IS NULL) THEN
         json_.put('select', JSON_OBJECT_T());
      ELSE
         json_.put('select', rec_.select_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_From (
   rec_   IN OUT NOCOPY OfflineQuery_Rec,
   value_ IN            OfflineQueryFromClause_Rec )
IS
BEGIN
   rec_.from_ := Build_Json___(value_);
END Set_From;

  

PROCEDURE Add_Joins (
   rec_   IN OUT NOCOPY OfflineQuery_Rec,
   value_ IN            OfflineQueryJoinClause_Rec )
IS
BEGIN
   IF (rec_.joins_ IS NULL) THEN
      rec_.joins_ := JSON_ARRAY_T();
   END IF;
   rec_.joins_.append(Build_Json___(value_));
END Add_Joins;

  

PROCEDURE Set_Where (
   rec_   IN OUT NOCOPY OfflineQuery_Rec,
   value_ IN            OfflineQueryWhereClause_Rec )
IS
BEGIN
   rec_.where_ := Build_Json___(value_);
END Set_Where;

  

PROCEDURE Set_Select (
   rec_   IN OUT NOCOPY OfflineQuery_Rec,
   value_ IN            OfflineQuerySelectClause_Rec )
IS
BEGIN
   rec_.select_ := Build_Json___(value_);
END Set_Select;


FUNCTION Build (
   rec_   IN OfflineQueryFromClause_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN OfflineQueryFromClause_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (TRUE) THEN
      json_.put('alias', rec_.alias_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY OfflineQueryFromClause_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;
  
PROCEDURE Set_Alias (
   rec_   IN OUT NOCOPY OfflineQueryFromClause_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.alias_ := value_;
END Set_Alias;

FUNCTION Build (
   rec_   IN OfflineQueryJoinClause_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN OfflineQueryJoinClause_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('dummy', rec_.dummy_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Dummy (
   rec_   IN OUT NOCOPY OfflineQueryJoinClause_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.dummy_ := value_;
END Set_Dummy;

FUNCTION Build (
   rec_   IN OfflineQueryWhereClause_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN OfflineQueryWhereClause_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('dummy', rec_.dummy_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Dummy (
   rec_   IN OUT NOCOPY OfflineQueryWhereClause_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.dummy_ := value_;
END Set_Dummy;

FUNCTION Build (
   rec_   IN OfflineQuerySelectClause_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN OfflineQuerySelectClause_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('dummy', rec_.dummy_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Dummy (
   rec_   IN OUT NOCOPY OfflineQuerySelectClause_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.dummy_ := value_;
END Set_Dummy;
----------------------------- LAYOUT COMPONENTS -----------------------------

FUNCTION Build (
   rec_   IN Layout_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Layout_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.assistants_ IS NOT NULL) THEN
      IF (rec_.assistants_ IS NULL) THEN
         json_.put('assistants', JSON_OBJECT_T());
      ELSE
         json_.put('assistants', rec_.assistants_);
      END IF;
   END IF;
   IF (rec_.barcharts_ IS NOT NULL) THEN
      IF (rec_.barcharts_ IS NULL) THEN
         json_.put('barcharts', JSON_OBJECT_T());
      ELSE
         json_.put('barcharts', rec_.barcharts_);
      END IF;
   END IF;
   IF (rec_.boxmatrices_ IS NOT NULL) THEN
      IF (rec_.boxmatrices_ IS NULL) THEN
         json_.put('boxmatrices', JSON_OBJECT_T());
      ELSE
         json_.put('boxmatrices', rec_.boxmatrices_);
      END IF;
   END IF;
   IF (rec_.calendars_ IS NOT NULL) THEN
      IF (rec_.calendars_ IS NULL) THEN
         json_.put('calendars', JSON_OBJECT_T());
      ELSE
         json_.put('calendars', rec_.calendars_);
      END IF;
   END IF;
   IF (rec_.cards_ IS NOT NULL) THEN
      IF (rec_.cards_ IS NULL) THEN
         json_.put('cards', JSON_OBJECT_T());
      ELSE
         json_.put('cards', rec_.cards_);
      END IF;
   END IF;
   IF (rec_.searchcontexts_ IS NOT NULL) THEN
      IF (rec_.searchcontexts_ IS NULL) THEN
         json_.put('searchcontexts', JSON_OBJECT_T());
      ELSE
         json_.put('searchcontexts', rec_.searchcontexts_);
      END IF;
   END IF;
   IF (rec_.dialogs_ IS NOT NULL) THEN
      IF (rec_.dialogs_ IS NULL) THEN
         json_.put('dialogs', JSON_OBJECT_T());
      ELSE
         json_.put('dialogs', rec_.dialogs_);
      END IF;
   END IF;
   IF (rec_.fields_ IS NOT NULL) THEN
      IF (rec_.fields_ IS NULL) THEN
         json_.put('fields', JSON_OBJECT_T());
      ELSE
         json_.put('fields', rec_.fields_);
      END IF;
   END IF;
   IF (rec_.fieldsets_ IS NOT NULL) THEN
      IF (rec_.fieldsets_ IS NULL) THEN
         json_.put('fieldsets', JSON_OBJECT_T());
      ELSE
         json_.put('fieldsets', rec_.fieldsets_);
      END IF;
   END IF;
   IF (rec_.ganttcharts_ IS NOT NULL) THEN
      IF (rec_.ganttcharts_ IS NULL) THEN
         json_.put('ganttcharts', JSON_OBJECT_T());
      ELSE
         json_.put('ganttcharts', rec_.ganttcharts_);
      END IF;
   END IF;
   IF (rec_.ganttchartitems_ IS NOT NULL) THEN
      IF (rec_.ganttchartitems_ IS NULL) THEN
         json_.put('ganttchartitems', JSON_OBJECT_T());
      ELSE
         json_.put('ganttchartitems', rec_.ganttchartitems_);
      END IF;
   END IF;
   IF (rec_.ganttchartrows_ IS NOT NULL) THEN
      IF (rec_.ganttchartrows_ IS NULL) THEN
         json_.put('ganttchartrows', JSON_OBJECT_T());
      ELSE
         json_.put('ganttchartrows', rec_.ganttchartrows_);
      END IF;
   END IF;
   IF (rec_.ganttchartitemstyles_ IS NOT NULL) THEN
      IF (rec_.ganttchartitemstyles_ IS NULL) THEN
         json_.put('ganttchartitemstyles', JSON_OBJECT_T());
      ELSE
         json_.put('ganttchartitemstyles', rec_.ganttchartitemstyles_);
      END IF;
   END IF;
   IF (rec_.ganttchartrowicons_ IS NOT NULL) THEN
      IF (rec_.ganttchartrowicons_ IS NULL) THEN
         json_.put('ganttchartrowicons', JSON_OBJECT_T());
      ELSE
         json_.put('ganttchartrowicons', rec_.ganttchartrowicons_);
      END IF;
   END IF;
   IF (rec_.ganttdependencys_ IS NOT NULL) THEN
      IF (rec_.ganttdependencys_ IS NULL) THEN
         json_.put('ganttdependencys', JSON_OBJECT_T());
      ELSE
         json_.put('ganttdependencys', rec_.ganttdependencys_);
      END IF;
   END IF;
   IF (rec_.ganttcharttimemarkers_ IS NOT NULL) THEN
      IF (rec_.ganttcharttimemarkers_ IS NULL) THEN
         json_.put('ganttcharttimemarkers', JSON_OBJECT_T());
      ELSE
         json_.put('ganttcharttimemarkers', rec_.ganttcharttimemarkers_);
      END IF;
   END IF;
   IF (rec_.ganttchart_schedules_ IS NOT NULL) THEN
      IF (rec_.ganttchart_schedules_ IS NULL) THEN
         json_.put('ganttchartSchedules', JSON_OBJECT_T());
      ELSE
         json_.put('ganttchartSchedules', rec_.ganttchart_schedules_);
      END IF;
   END IF;
   IF (rec_.ganttchartlegends_ IS NOT NULL) THEN
      IF (rec_.ganttchartlegends_ IS NULL) THEN
         json_.put('ganttchartlegends', JSON_OBJECT_T());
      ELSE
         json_.put('ganttchartlegends', rec_.ganttchartlegends_);
      END IF;
   END IF;
   IF (rec_.groups_ IS NOT NULL) THEN
      IF (rec_.groups_ IS NULL) THEN
         json_.put('groups', JSON_OBJECT_T());
      ELSE
         json_.put('groups', rec_.groups_);
      END IF;
   END IF;
   IF (rec_.imageviewers_ IS NOT NULL) THEN
      IF (rec_.imageviewers_ IS NULL) THEN
         json_.put('imageviewers', JSON_OBJECT_T());
      ELSE
         json_.put('imageviewers', rec_.imageviewers_);
      END IF;
   END IF;
   IF (rec_.processviewers_ IS NOT NULL) THEN
      IF (rec_.processviewers_ IS NULL) THEN
         json_.put('processviewers', JSON_OBJECT_T());
      ELSE
         json_.put('processviewers', rec_.processviewers_);
      END IF;
   END IF;
   IF (rec_.linecharts_ IS NOT NULL) THEN
      IF (rec_.linecharts_ IS NULL) THEN
         json_.put('linecharts', JSON_OBJECT_T());
      ELSE
         json_.put('linecharts', rec_.linecharts_);
      END IF;
   END IF;
   IF (rec_.lists_ IS NOT NULL) THEN
      IF (rec_.lists_ IS NULL) THEN
         json_.put('lists', JSON_OBJECT_T());
      ELSE
         json_.put('lists', rec_.lists_);
      END IF;
   END IF;
   IF (rec_.pages_ IS NOT NULL) THEN
      IF (rec_.pages_ IS NULL) THEN
         json_.put('pages', JSON_OBJECT_T());
      ELSE
         json_.put('pages', rec_.pages_);
      END IF;
   END IF;
   IF (rec_.piecharts_ IS NOT NULL) THEN
      IF (rec_.piecharts_ IS NULL) THEN
         json_.put('piecharts', JSON_OBJECT_T());
      ELSE
         json_.put('piecharts', rec_.piecharts_);
      END IF;
   END IF;
   IF (rec_.radarcharts_ IS NOT NULL) THEN
      IF (rec_.radarcharts_ IS NULL) THEN
         json_.put('radarcharts', JSON_OBJECT_T());
      ELSE
         json_.put('radarcharts', rec_.radarcharts_);
      END IF;
   END IF;
   IF (rec_.stackedcalendars_ IS NOT NULL) THEN
      IF (rec_.stackedcalendars_ IS NULL) THEN
         json_.put('stackedcalendars', JSON_OBJECT_T());
      ELSE
         json_.put('stackedcalendars', rec_.stackedcalendars_);
      END IF;
   END IF;
   IF (rec_.selectors_ IS NOT NULL) THEN
      IF (rec_.selectors_ IS NULL) THEN
         json_.put('selectors', JSON_OBJECT_T());
      ELSE
         json_.put('selectors', rec_.selectors_);
      END IF;
   END IF;
   IF (rec_.singletons_ IS NOT NULL) THEN
      IF (rec_.singletons_ IS NULL) THEN
         json_.put('singletons', JSON_OBJECT_T());
      ELSE
         json_.put('singletons', rec_.singletons_);
      END IF;
   END IF;
   IF (rec_.sheets_ IS NOT NULL) THEN
      IF (rec_.sheets_ IS NULL) THEN
         json_.put('sheets', JSON_OBJECT_T());
      ELSE
         json_.put('sheets', rec_.sheets_);
      END IF;
   END IF;
   IF (rec_.stackedcharts_ IS NOT NULL) THEN
      IF (rec_.stackedcharts_ IS NULL) THEN
         json_.put('stackedcharts', JSON_OBJECT_T());
      ELSE
         json_.put('stackedcharts', rec_.stackedcharts_);
      END IF;
   END IF;
   IF (rec_.trees_ IS NOT NULL) THEN
      IF (rec_.trees_ IS NULL) THEN
         json_.put('trees', JSON_OBJECT_T());
      ELSE
         json_.put('trees', rec_.trees_);
      END IF;
   END IF;
   IF (rec_.stateindicators_ IS NOT NULL) THEN
      IF (rec_.stateindicators_ IS NULL) THEN
         json_.put('stateindicators', JSON_OBJECT_T());
      ELSE
         json_.put('stateindicators', rec_.stateindicators_);
      END IF;
   END IF;
   IF (rec_.timelines_ IS NOT NULL) THEN
      IF (rec_.timelines_ IS NULL) THEN
         json_.put('timelines', JSON_OBJECT_T());
      ELSE
         json_.put('timelines', rec_.timelines_);
      END IF;
   END IF;
   IF (rec_.yearviews_ IS NOT NULL) THEN
      IF (rec_.yearviews_ IS NULL) THEN
         json_.put('yearviews', JSON_OBJECT_T());
      ELSE
         json_.put('yearviews', rec_.yearviews_);
      END IF;
   END IF;
   IF (rec_.commands_ IS NOT NULL) THEN
      IF (rec_.commands_ IS NULL) THEN
         json_.put('commands', JSON_OBJECT_T());
      ELSE
         json_.put('commands', rec_.commands_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Add_Assistants (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Assistant_Rec )
IS
BEGIN
   IF (rec_.assistants_ IS NULL) THEN
      rec_.assistants_ := JSON_OBJECT_T();
   END IF;
   rec_.assistants_.put(name_, Build_Json___(value_));
END Add_Assistants;

  

PROCEDURE Add_Barcharts (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Barchart_Rec )
IS
BEGIN
   IF (rec_.barcharts_ IS NULL) THEN
      rec_.barcharts_ := JSON_OBJECT_T();
   END IF;
   rec_.barcharts_.put(name_, Build_Json___(value_));
END Add_Barcharts;

  

PROCEDURE Add_Boxmatrices (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            BoxMatrix_Rec )
IS
BEGIN
   IF (rec_.boxmatrices_ IS NULL) THEN
      rec_.boxmatrices_ := JSON_OBJECT_T();
   END IF;
   rec_.boxmatrices_.put(name_, Build_Json___(value_));
END Add_Boxmatrices;

  

PROCEDURE Add_Calendars (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Calendar_Rec )
IS
BEGIN
   IF (rec_.calendars_ IS NULL) THEN
      rec_.calendars_ := JSON_OBJECT_T();
   END IF;
   rec_.calendars_.put(name_, Build_Json___(value_));
END Add_Calendars;

  

PROCEDURE Add_Cards (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Card_Rec )
IS
BEGIN
   IF (rec_.cards_ IS NULL) THEN
      rec_.cards_ := JSON_OBJECT_T();
   END IF;
   rec_.cards_.put(name_, Build_Json___(value_));
END Add_Cards;

  

PROCEDURE Add_Searchcontexts (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            SearchContext_Rec )
IS
BEGIN
   IF (rec_.searchcontexts_ IS NULL) THEN
      rec_.searchcontexts_ := JSON_OBJECT_T();
   END IF;
   rec_.searchcontexts_.put(name_, Build_Json___(value_));
END Add_Searchcontexts;

  

PROCEDURE Add_Dialogs (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Dialog_Rec )
IS
BEGIN
   IF (rec_.dialogs_ IS NULL) THEN
      rec_.dialogs_ := JSON_OBJECT_T();
   END IF;
   rec_.dialogs_.put(name_, Build_Json___(value_));
END Add_Dialogs;

  

PROCEDURE Add_Fields (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Field_Rec )
IS
BEGIN
   IF (rec_.fields_ IS NULL) THEN
      rec_.fields_ := JSON_OBJECT_T();
   END IF;
   rec_.fields_.put(name_, Build_Json___(value_));
END Add_Fields;

  

PROCEDURE Add_Fieldsets (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            FieldSet_Rec )
IS
BEGIN
   IF (rec_.fieldsets_ IS NULL) THEN
      rec_.fieldsets_ := JSON_OBJECT_T();
   END IF;
   rec_.fieldsets_.put(name_, Build_Json___(value_));
END Add_Fieldsets;

  

PROCEDURE Add_Ganttcharts (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Ganttchart_Rec )
IS
BEGIN
   IF (rec_.ganttcharts_ IS NULL) THEN
      rec_.ganttcharts_ := JSON_OBJECT_T();
   END IF;
   rec_.ganttcharts_.put(name_, Build_Json___(value_));
END Add_Ganttcharts;

  

PROCEDURE Add_Ganttchartitems (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            GanttchartItem_Rec )
IS
BEGIN
   IF (rec_.ganttchartitems_ IS NULL) THEN
      rec_.ganttchartitems_ := JSON_OBJECT_T();
   END IF;
   rec_.ganttchartitems_.put(name_, Build_Json___(value_));
END Add_Ganttchartitems;

  

PROCEDURE Add_Ganttchartrows (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            GanttchartRow_Rec )
IS
BEGIN
   IF (rec_.ganttchartrows_ IS NULL) THEN
      rec_.ganttchartrows_ := JSON_OBJECT_T();
   END IF;
   rec_.ganttchartrows_.put(name_, Build_Json___(value_));
END Add_Ganttchartrows;

  

PROCEDURE Add_Ganttchartitemstyles (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            GanttchartItemStyle_Rec )
IS
BEGIN
   IF (rec_.ganttchartitemstyles_ IS NULL) THEN
      rec_.ganttchartitemstyles_ := JSON_OBJECT_T();
   END IF;
   rec_.ganttchartitemstyles_.put(name_, Build_Json___(value_));
END Add_Ganttchartitemstyles;

  

PROCEDURE Add_Ganttchartrowicons (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            GanttchartRowIcon_Rec )
IS
BEGIN
   IF (rec_.ganttchartrowicons_ IS NULL) THEN
      rec_.ganttchartrowicons_ := JSON_OBJECT_T();
   END IF;
   rec_.ganttchartrowicons_.put(name_, Build_Json___(value_));
END Add_Ganttchartrowicons;

  

PROCEDURE Add_Ganttdependencys (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            GanttDependency_Rec )
IS
BEGIN
   IF (rec_.ganttdependencys_ IS NULL) THEN
      rec_.ganttdependencys_ := JSON_OBJECT_T();
   END IF;
   rec_.ganttdependencys_.put(name_, Build_Json___(value_));
END Add_Ganttdependencys;

  

PROCEDURE Add_Ganttcharttimemarkers (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            GanttchartTimemarker_Rec )
IS
BEGIN
   IF (rec_.ganttcharttimemarkers_ IS NULL) THEN
      rec_.ganttcharttimemarkers_ := JSON_OBJECT_T();
   END IF;
   rec_.ganttcharttimemarkers_.put(name_, Build_Json___(value_));
END Add_Ganttcharttimemarkers;

  

PROCEDURE Add_Ganttchart_Schedules (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            GanttchartSchedule_Rec )
IS
BEGIN
   IF (rec_.ganttchart_schedules_ IS NULL) THEN
      rec_.ganttchart_schedules_ := JSON_OBJECT_T();
   END IF;
   rec_.ganttchart_schedules_.put(name_, Build_Json___(value_));
END Add_Ganttchart_Schedules;

  

PROCEDURE Add_Ganttchartlegends (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            GanttchartLegend_Rec )
IS
BEGIN
   IF (rec_.ganttchartlegends_ IS NULL) THEN
      rec_.ganttchartlegends_ := JSON_OBJECT_T();
   END IF;
   rec_.ganttchartlegends_.put(name_, Build_Json___(value_));
END Add_Ganttchartlegends;

  

PROCEDURE Add_Groups (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Group_Rec )
IS
BEGIN
   IF (rec_.groups_ IS NULL) THEN
      rec_.groups_ := JSON_OBJECT_T();
   END IF;
   rec_.groups_.put(name_, Build_Json___(value_));
END Add_Groups;

  

PROCEDURE Add_Imageviewers (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Imageviewer_Rec )
IS
BEGIN
   IF (rec_.imageviewers_ IS NULL) THEN
      rec_.imageviewers_ := JSON_OBJECT_T();
   END IF;
   rec_.imageviewers_.put(name_, Build_Json___(value_));
END Add_Imageviewers;

  

PROCEDURE Add_Processviewers (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Processviewer_Rec )
IS
BEGIN
   IF (rec_.processviewers_ IS NULL) THEN
      rec_.processviewers_ := JSON_OBJECT_T();
   END IF;
   rec_.processviewers_.put(name_, Build_Json___(value_));
END Add_Processviewers;

  

PROCEDURE Add_Linecharts (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Linechart_Rec )
IS
BEGIN
   IF (rec_.linecharts_ IS NULL) THEN
      rec_.linecharts_ := JSON_OBJECT_T();
   END IF;
   rec_.linecharts_.put(name_, Build_Json___(value_));
END Add_Linecharts;

  

PROCEDURE Add_Lists (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            List_Rec )
IS
BEGIN
   IF (rec_.lists_ IS NULL) THEN
      rec_.lists_ := JSON_OBJECT_T();
   END IF;
   rec_.lists_.put(name_, Build_Json___(value_));
END Add_Lists;

  

PROCEDURE Add_Pages (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Page_Rec )
IS
BEGIN
   IF (rec_.pages_ IS NULL) THEN
      rec_.pages_ := JSON_OBJECT_T();
   END IF;
   rec_.pages_.put(name_, Build_Json___(value_));
END Add_Pages;

  

PROCEDURE Add_Piecharts (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Piechart_Rec )
IS
BEGIN
   IF (rec_.piecharts_ IS NULL) THEN
      rec_.piecharts_ := JSON_OBJECT_T();
   END IF;
   rec_.piecharts_.put(name_, Build_Json___(value_));
END Add_Piecharts;

  

PROCEDURE Add_Radarcharts (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Radarchart_Rec )
IS
BEGIN
   IF (rec_.radarcharts_ IS NULL) THEN
      rec_.radarcharts_ := JSON_OBJECT_T();
   END IF;
   rec_.radarcharts_.put(name_, Build_Json___(value_));
END Add_Radarcharts;

  

PROCEDURE Add_Stackedcalendars (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            StackedCalendar_Rec )
IS
BEGIN
   IF (rec_.stackedcalendars_ IS NULL) THEN
      rec_.stackedcalendars_ := JSON_OBJECT_T();
   END IF;
   rec_.stackedcalendars_.put(name_, Build_Json___(value_));
END Add_Stackedcalendars;

  

PROCEDURE Add_Selectors (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Selector_Rec )
IS
BEGIN
   IF (rec_.selectors_ IS NULL) THEN
      rec_.selectors_ := JSON_OBJECT_T();
   END IF;
   rec_.selectors_.put(name_, Build_Json___(value_));
END Add_Selectors;

  

PROCEDURE Add_Singletons (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Singleton_Rec )
IS
BEGIN
   IF (rec_.singletons_ IS NULL) THEN
      rec_.singletons_ := JSON_OBJECT_T();
   END IF;
   rec_.singletons_.put(name_, Build_Json___(value_));
END Add_Singletons;

  

PROCEDURE Add_Sheets (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Sheet_Rec )
IS
BEGIN
   IF (rec_.sheets_ IS NULL) THEN
      rec_.sheets_ := JSON_OBJECT_T();
   END IF;
   rec_.sheets_.put(name_, Build_Json___(value_));
END Add_Sheets;

  

PROCEDURE Add_Stackedcharts (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Stackedchart_Rec )
IS
BEGIN
   IF (rec_.stackedcharts_ IS NULL) THEN
      rec_.stackedcharts_ := JSON_OBJECT_T();
   END IF;
   rec_.stackedcharts_.put(name_, Build_Json___(value_));
END Add_Stackedcharts;

  

PROCEDURE Add_Trees (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            TreeView_Rec )
IS
BEGIN
   IF (rec_.trees_ IS NULL) THEN
      rec_.trees_ := JSON_OBJECT_T();
   END IF;
   rec_.trees_.put(name_, Build_Json___(value_));
END Add_Trees;

  

PROCEDURE Add_Stateindicators (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            StateIndicator_Rec )
IS
BEGIN
   IF (rec_.stateindicators_ IS NULL) THEN
      rec_.stateindicators_ := JSON_OBJECT_T();
   END IF;
   rec_.stateindicators_.put(name_, Build_Json___(value_));
END Add_Stateindicators;

  

PROCEDURE Add_Timelines (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Timeline_Rec )
IS
BEGIN
   IF (rec_.timelines_ IS NULL) THEN
      rec_.timelines_ := JSON_OBJECT_T();
   END IF;
   rec_.timelines_.put(name_, Build_Json___(value_));
END Add_Timelines;

  

PROCEDURE Add_Yearviews (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            YearView_Rec )
IS
BEGIN
   IF (rec_.yearviews_ IS NULL) THEN
      rec_.yearviews_ := JSON_OBJECT_T();
   END IF;
   rec_.yearviews_.put(name_, Build_Json___(value_));
END Add_Yearviews;

  

PROCEDURE Add_Commands (
   rec_   IN OUT NOCOPY Layout_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Command_Rec )
IS
BEGIN
   IF (rec_.commands_ IS NULL) THEN
      rec_.commands_ := JSON_OBJECT_T();
   END IF;
   rec_.commands_.put(name_, Build_Json___(value_));
END Add_Commands;


FUNCTION Build (
   rec_   IN Chart_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Chart_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      json_.put('collapsed', rec_.collapsed_);
   END IF;
   IF (rec_.height_ IS NOT NULL) THEN
      json_.put('height', rec_.height_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Chart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Chart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Chart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Chart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Chart_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;
  
PROCEDURE Set_Height (
   rec_   IN OUT NOCOPY Chart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.height_ := value_;
END Set_Height;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY Chart_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;

FUNCTION Build (
   rec_   IN ChartAxisColumn_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ChartAxisColumn_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('attribute', rec_.attribute_);
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Attribute (
   rec_   IN OUT NOCOPY ChartAxisColumn_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.attribute_ := value_;
END Set_Attribute;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY ChartAxisColumn_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY ChartAxisColumn_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;

FUNCTION Build (
   rec_   IN ChartElementOverride_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ChartElementOverride_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      IF (rec_.collapsed_ = 'TRUE') THEN
         json_.put('collapsed', TRUE);
      ELSIF (rec_.collapsed_ = 'FALSE') THEN
         json_.put('collapsed', FALSE);
      ELSE
         json_.put('collapsed', rec_.collapsed_);
      END IF;
   END IF;
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY ChartElementOverride_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY ChartElementOverride_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY ChartElementOverride_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;


PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY ChartElementOverride_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Collapsed;
  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY ChartElementOverride_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY ChartElementOverride_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY ChartElementOverride_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;

FUNCTION Build (
   rec_   IN PiechartElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN PiechartElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'piechart');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('piechart', rec_.piechart_);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (rec_.detail_page_ IS NOT NULL) THEN
      json_.put('detailPage', rec_.detail_page_);
   END IF;
   IF (rec_.override_ IS NOT NULL) THEN
      IF (rec_.override_ IS NULL) THEN
         json_.put('override', JSON_OBJECT_T());
      ELSE
         json_.put('override', rec_.override_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY PiechartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY PiechartElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Piechart (
   rec_   IN OUT NOCOPY PiechartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.piechart_ := value_;
END Set_Piechart;

  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY PiechartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY PiechartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY PiechartElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  
PROCEDURE Set_Detail_Page (
   rec_   IN OUT NOCOPY PiechartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.detail_page_ := value_;
END Set_Detail_Page;
  

PROCEDURE Set_Override (
   rec_   IN OUT NOCOPY PiechartElement_Rec,
   value_ IN            ChartElementOverride_Rec )
IS
BEGIN
   rec_.override_ := Build_Json___(value_);
END Set_Override;


FUNCTION Build (
   rec_   IN Piechart_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Piechart_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      json_.put('collapsed', rec_.collapsed_);
   END IF;
   IF (rec_.height_ IS NOT NULL) THEN
      json_.put('height', rec_.height_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   IF (rec_.center_label_ IS NOT NULL) THEN
      json_.put('centerLabel', rec_.center_label_);
   END IF;
   IF (rec_.top_n_ IS NOT NULL) THEN
      IF (rec_.top_n_ IS NULL) THEN
         json_.put('topN', JSON_OBJECT_T());
      ELSE
         json_.put('topN', rec_.top_n_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.series_ IS NULL) THEN
         json_.put('series', JSON_OBJECT_T());
      ELSE
         json_.put('series', rec_.series_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Piechart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Piechart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Piechart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Piechart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Piechart_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;
  
PROCEDURE Set_Height (
   rec_   IN OUT NOCOPY Piechart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.height_ := value_;
END Set_Height;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY Piechart_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;
  
PROCEDURE Set_Center_Label (
   rec_   IN OUT NOCOPY Piechart_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.center_label_ := value_;
END Set_Center_Label;
  

PROCEDURE Set_Top_N (
   rec_   IN OUT NOCOPY Piechart_Rec,
   value_ IN            TopN_Rec )
IS
BEGIN
   rec_.top_n_ := Build_Json___(value_);
END Set_Top_N;

  

PROCEDURE Set_Series (
   rec_   IN OUT NOCOPY Piechart_Rec,
   value_ IN            PieSeries_Rec )
IS
BEGIN
   rec_.series_ := Build_Json___(value_);
END Set_Series;


FUNCTION Build (
   rec_   IN PieSeries_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN PieSeries_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.axis_label_ IS NOT NULL) THEN
      json_.put('axisLabel', rec_.axis_label_);
   END IF;
   IF (TRUE) THEN
      json_.put('argumentColumn', rec_.argument_column_);
   END IF;
   IF (TRUE) THEN
      json_.put('argumentValue', rec_.argument_value_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Axis_Label (
   rec_   IN OUT NOCOPY PieSeries_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.axis_label_ := value_;
END Set_Axis_Label;
  
PROCEDURE Set_Argument_Column (
   rec_   IN OUT NOCOPY PieSeries_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.argument_column_ := value_;
END Set_Argument_Column;
  
PROCEDURE Set_Argument_Value (
   rec_   IN OUT NOCOPY PieSeries_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.argument_value_ := value_;
END Set_Argument_Value;

FUNCTION Build (
   rec_   IN TopN_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN TopN_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.mode_ IS NOT NULL) THEN
      json_.put('mode', rec_.mode_);
   END IF;
   IF (rec_.value_ IS NOT NULL) THEN
      json_.put('value', rec_.value_);
   END IF;
   IF (rec_.show_others_ IS NOT NULL) THEN
      json_.put('showOthers', rec_.show_others_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Mode (
   rec_   IN OUT NOCOPY TopN_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.mode_ := value_;
END Set_Mode;
  

PROCEDURE Set_Value (
   rec_   IN OUT NOCOPY TopN_Rec,
   value_ IN            NUMBER )
IS
BEGIN
   rec_.value_ := value_;
END Set_Value;

  
PROCEDURE Set_Show_Others (
   rec_   IN OUT NOCOPY TopN_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.show_others_ := value_;
END Set_Show_Others;

FUNCTION Build (
   rec_   IN BarchartElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BarchartElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'barchart');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('barchart', rec_.barchart_);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (rec_.detail_page_ IS NOT NULL) THEN
      json_.put('detailPage', rec_.detail_page_);
   END IF;
   IF (rec_.override_ IS NOT NULL) THEN
      IF (rec_.override_ IS NULL) THEN
         json_.put('override', JSON_OBJECT_T());
      ELSE
         json_.put('override', rec_.override_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY BarchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY BarchartElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Barchart (
   rec_   IN OUT NOCOPY BarchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.barchart_ := value_;
END Set_Barchart;

  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY BarchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY BarchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY BarchartElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  
PROCEDURE Set_Detail_Page (
   rec_   IN OUT NOCOPY BarchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.detail_page_ := value_;
END Set_Detail_Page;
  

PROCEDURE Set_Override (
   rec_   IN OUT NOCOPY BarchartElement_Rec,
   value_ IN            ChartElementOverride_Rec )
IS
BEGIN
   rec_.override_ := Build_Json___(value_);
END Set_Override;


FUNCTION Build (
   rec_   IN Barchart_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Barchart_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      json_.put('collapsed', rec_.collapsed_);
   END IF;
   IF (rec_.height_ IS NOT NULL) THEN
      json_.put('height', rec_.height_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   IF (rec_.orientation_ IS NOT NULL) THEN
      json_.put('orientation', rec_.orientation_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.series_ IS NULL) THEN
         json_.put('series', JSON_OBJECT_T());
      ELSE
         json_.put('series', rec_.series_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Barchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Barchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Barchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Barchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Barchart_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;
  
PROCEDURE Set_Height (
   rec_   IN OUT NOCOPY Barchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.height_ := value_;
END Set_Height;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY Barchart_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;
  
PROCEDURE Set_Orientation (
   rec_   IN OUT NOCOPY Barchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.orientation_ := value_;
END Set_Orientation;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY Barchart_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;
  

PROCEDURE Set_Series (
   rec_   IN OUT NOCOPY Barchart_Rec,
   value_ IN            BarchartSeries_Rec )
IS
BEGIN
   rec_.series_ := Build_Json___(value_);
END Set_Series;


FUNCTION Build (
   rec_   IN BarchartSeries_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BarchartSeries_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.x_column_ IS NULL) THEN
         json_.put('xColumn', JSON_OBJECT_T());
      ELSE
         json_.put('xColumn', rec_.x_column_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.y_column_ IS NULL) THEN
         json_.put('yColumn', JSON_OBJECT_T());
      ELSE
         json_.put('yColumn', rec_.y_column_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.split_column_ IS NULL) THEN
         json_.put('splitColumn', JSON_OBJECT_T());
      ELSE
         json_.put('splitColumn', rec_.split_column_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.top_n_ IS NULL) THEN
         json_.put('topN', JSON_OBJECT_T());
      ELSE
         json_.put('topN', rec_.top_n_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_X_Column (
   rec_   IN OUT NOCOPY BarchartSeries_Rec,
   value_ IN            BarchartXColumn_Rec )
IS
BEGIN
   rec_.x_column_ := Build_Json___(value_);
END Set_X_Column;

  

PROCEDURE Set_Y_Column (
   rec_   IN OUT NOCOPY BarchartSeries_Rec,
   value_ IN            BarchartYColumn_Rec )
IS
BEGIN
   rec_.y_column_ := Build_Json___(value_);
END Set_Y_Column;

  

PROCEDURE Set_Split_Column (
   rec_   IN OUT NOCOPY BarchartSeries_Rec,
   value_ IN            BarchartSplitColumn_Rec )
IS
BEGIN
   rec_.split_column_ := Build_Json___(value_);
END Set_Split_Column;

  

PROCEDURE Set_Top_N (
   rec_   IN OUT NOCOPY BarchartSeries_Rec,
   value_ IN            TopN_Rec )
IS
BEGIN
   rec_.top_n_ := Build_Json___(value_);
END Set_Top_N;


FUNCTION Build (
   rec_   IN BarchartXColumn_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BarchartXColumn_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('axisLabel', rec_.axis_label_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.column_ IS NULL) THEN
         json_.put('column', JSON_OBJECT_T());
      ELSE
         json_.put('column', rec_.column_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Axis_Label (
   rec_   IN OUT NOCOPY BarchartXColumn_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.axis_label_ := value_;
END Set_Axis_Label;
  

PROCEDURE Set_Column (
   rec_   IN OUT NOCOPY BarchartXColumn_Rec,
   value_ IN            ChartAxisColumn_Rec )
IS
BEGIN
   rec_.column_ := Build_Json___(value_);
END Set_Column;


FUNCTION Build (
   rec_   IN BarchartYColumn_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BarchartYColumn_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('axisLabel', rec_.axis_label_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Axis_Label (
   rec_   IN OUT NOCOPY BarchartYColumn_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.axis_label_ := value_;
END Set_Axis_Label;
  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY BarchartYColumn_Rec,
   value_ IN            BarchartYColumnContent_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


FUNCTION Build (
   rec_   IN BarchartYColumnContent_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BarchartYColumnContent_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.column_ IS NULL) THEN
         json_.put('column', JSON_OBJECT_T());
      ELSE
         json_.put('column', rec_.column_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Column (
   rec_   IN OUT NOCOPY BarchartYColumnContent_Rec,
   value_ IN            ChartAxisColumn_Rec )
IS
BEGIN
   rec_.column_ := Build_Json___(value_);
END Set_Column;


FUNCTION Build (
   rec_   IN BarchartSplitColumn_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BarchartSplitColumn_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY BarchartSplitColumn_Rec,
   value_ IN            BarchartSplitColumnContent_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


FUNCTION Build (
   rec_   IN BarchartSplitColumnContent_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BarchartSplitColumnContent_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.column_ IS NULL) THEN
         json_.put('column', JSON_OBJECT_T());
      ELSE
         json_.put('column', rec_.column_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Column (
   rec_   IN OUT NOCOPY BarchartSplitColumnContent_Rec,
   value_ IN            ChartAxisColumn_Rec )
IS
BEGIN
   rec_.column_ := Build_Json___(value_);
END Set_Column;


FUNCTION Build (
   rec_   IN StackedchartElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN StackedchartElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'stackedchart');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('stackedchart', rec_.stackedchart_);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (rec_.detail_page_ IS NOT NULL) THEN
      json_.put('detailPage', rec_.detail_page_);
   END IF;
   IF (rec_.override_ IS NOT NULL) THEN
      IF (rec_.override_ IS NULL) THEN
         json_.put('override', JSON_OBJECT_T());
      ELSE
         json_.put('override', rec_.override_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY StackedchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY StackedchartElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Stackedchart (
   rec_   IN OUT NOCOPY StackedchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.stackedchart_ := value_;
END Set_Stackedchart;

  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY StackedchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY StackedchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY StackedchartElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  
PROCEDURE Set_Detail_Page (
   rec_   IN OUT NOCOPY StackedchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.detail_page_ := value_;
END Set_Detail_Page;
  

PROCEDURE Set_Override (
   rec_   IN OUT NOCOPY StackedchartElement_Rec,
   value_ IN            ChartElementOverride_Rec )
IS
BEGIN
   rec_.override_ := Build_Json___(value_);
END Set_Override;


FUNCTION Build (
   rec_   IN Stackedchart_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Stackedchart_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      json_.put('collapsed', rec_.collapsed_);
   END IF;
   IF (rec_.height_ IS NOT NULL) THEN
      json_.put('height', rec_.height_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   IF (rec_.orientation_ IS NOT NULL) THEN
      json_.put('orientation', rec_.orientation_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.series_ IS NULL) THEN
         json_.put('series', JSON_OBJECT_T());
      ELSE
         json_.put('series', rec_.series_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('fullStacked', rec_.full_stacked_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Stackedchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Stackedchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Stackedchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Stackedchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Stackedchart_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;
  
PROCEDURE Set_Height (
   rec_   IN OUT NOCOPY Stackedchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.height_ := value_;
END Set_Height;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY Stackedchart_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;
  
PROCEDURE Set_Orientation (
   rec_   IN OUT NOCOPY Stackedchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.orientation_ := value_;
END Set_Orientation;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY Stackedchart_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;
  

PROCEDURE Set_Series (
   rec_   IN OUT NOCOPY Stackedchart_Rec,
   value_ IN            BarchartSeries_Rec )
IS
BEGIN
   rec_.series_ := Build_Json___(value_);
END Set_Series;

  
PROCEDURE Set_Full_Stacked (
   rec_   IN OUT NOCOPY Stackedchart_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.full_stacked_ := value_;
END Set_Full_Stacked;

FUNCTION Build (
   rec_   IN LinechartElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN LinechartElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'linechart');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('linechart', rec_.linechart_);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (rec_.detail_page_ IS NOT NULL) THEN
      json_.put('detailPage', rec_.detail_page_);
   END IF;
   IF (rec_.override_ IS NOT NULL) THEN
      IF (rec_.override_ IS NULL) THEN
         json_.put('override', JSON_OBJECT_T());
      ELSE
         json_.put('override', rec_.override_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY LinechartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY LinechartElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Linechart (
   rec_   IN OUT NOCOPY LinechartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.linechart_ := value_;
END Set_Linechart;

  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY LinechartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY LinechartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY LinechartElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  
PROCEDURE Set_Detail_Page (
   rec_   IN OUT NOCOPY LinechartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.detail_page_ := value_;
END Set_Detail_Page;
  

PROCEDURE Set_Override (
   rec_   IN OUT NOCOPY LinechartElement_Rec,
   value_ IN            ChartElementOverride_Rec )
IS
BEGIN
   rec_.override_ := Build_Json___(value_);
END Set_Override;


FUNCTION Build (
   rec_   IN Linechart_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Linechart_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      json_.put('collapsed', rec_.collapsed_);
   END IF;
   IF (rec_.height_ IS NOT NULL) THEN
      json_.put('height', rec_.height_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   IF (rec_.orientation_ IS NOT NULL) THEN
      json_.put('orientation', rec_.orientation_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.series_ IS NULL) THEN
         json_.put('series', JSON_OBJECT_T());
      ELSE
         json_.put('series', rec_.series_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Linechart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Linechart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Linechart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Linechart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Linechart_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;
  
PROCEDURE Set_Height (
   rec_   IN OUT NOCOPY Linechart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.height_ := value_;
END Set_Height;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY Linechart_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;
  
PROCEDURE Set_Orientation (
   rec_   IN OUT NOCOPY Linechart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.orientation_ := value_;
END Set_Orientation;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY Linechart_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;
  

PROCEDURE Set_Series (
   rec_   IN OUT NOCOPY Linechart_Rec,
   value_ IN            BarchartSeries_Rec )
IS
BEGIN
   rec_.series_ := Build_Json___(value_);
END Set_Series;


FUNCTION Build (
   rec_   IN RadarchartElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN RadarchartElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'radarchart');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('radarchart', rec_.radarchart_);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (rec_.detail_page_ IS NOT NULL) THEN
      json_.put('detailPage', rec_.detail_page_);
   END IF;
   IF (rec_.override_ IS NOT NULL) THEN
      IF (rec_.override_ IS NULL) THEN
         json_.put('override', JSON_OBJECT_T());
      ELSE
         json_.put('override', rec_.override_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY RadarchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY RadarchartElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Radarchart (
   rec_   IN OUT NOCOPY RadarchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.radarchart_ := value_;
END Set_Radarchart;

  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY RadarchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY RadarchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY RadarchartElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  
PROCEDURE Set_Detail_Page (
   rec_   IN OUT NOCOPY RadarchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.detail_page_ := value_;
END Set_Detail_Page;
  

PROCEDURE Set_Override (
   rec_   IN OUT NOCOPY RadarchartElement_Rec,
   value_ IN            ChartElementOverride_Rec )
IS
BEGIN
   rec_.override_ := Build_Json___(value_);
END Set_Override;


FUNCTION Build (
   rec_   IN Radarchart_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Radarchart_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      json_.put('collapsed', rec_.collapsed_);
   END IF;
   IF (rec_.height_ IS NOT NULL) THEN
      json_.put('height', rec_.height_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   IF (rec_.transposed_ IS NOT NULL) THEN
      json_.put('transposed', rec_.transposed_);
   END IF;
   IF (rec_.series_ IS NOT NULL) THEN
      IF (rec_.series_ IS NULL) THEN
         json_.put('series', JSON_OBJECT_T());
      ELSE
         json_.put('series', rec_.series_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Radarchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Radarchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Radarchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Radarchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Radarchart_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;
  
PROCEDURE Set_Height (
   rec_   IN OUT NOCOPY Radarchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.height_ := value_;
END Set_Height;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY Radarchart_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;
  
PROCEDURE Set_Transposed (
   rec_   IN OUT NOCOPY Radarchart_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.transposed_ := value_;
END Set_Transposed;
  

PROCEDURE Set_Series (
   rec_   IN OUT NOCOPY Radarchart_Rec,
   value_ IN            RadarchartSeries_Rec )
IS
BEGIN
   rec_.series_ := Build_Json___(value_);
END Set_Series;


FUNCTION Build (
   rec_   IN RadarchartSeries_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN RadarchartSeries_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.x_column_ IS NULL) THEN
         json_.put('xColumn', JSON_OBJECT_T());
      ELSE
         json_.put('xColumn', rec_.x_column_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.y_column_ IS NULL) THEN
         json_.put('yColumn', JSON_OBJECT_T());
      ELSE
         json_.put('yColumn', rec_.y_column_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_X_Column (
   rec_   IN OUT NOCOPY RadarchartSeries_Rec,
   value_ IN            RadarchartSeriesColumn_Rec )
IS
BEGIN
   rec_.x_column_ := Build_Json___(value_);
END Set_X_Column;

  

PROCEDURE Set_Y_Column (
   rec_   IN OUT NOCOPY RadarchartSeries_Rec,
   value_ IN            RadarchartSeriesYColumn_Rec )
IS
BEGIN
   rec_.y_column_ := Build_Json___(value_);
END Set_Y_Column;


FUNCTION Build (
   rec_   IN RadarchartSeriesYColumn_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN RadarchartSeriesYColumn_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.content_ IS NOT NULL) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY RadarchartSeriesYColumn_Rec,
   value_ IN            RadarchartSeriesColumn_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


FUNCTION Build (
   rec_   IN RadarchartSeriesColumn_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN RadarchartSeriesColumn_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.column_ IS NOT NULL) THEN
      IF (rec_.column_ IS NULL) THEN
         json_.put('column', JSON_OBJECT_T());
      ELSE
         json_.put('column', rec_.column_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Column (
   rec_   IN OUT NOCOPY RadarchartSeriesColumn_Rec,
   value_ IN            RadarchartSeriesColumnContent_Rec )
IS
BEGIN
   rec_.column_ := Build_Json___(value_);
END Set_Column;


FUNCTION Build (
   rec_   IN RadarchartSeriesColumnContent_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN RadarchartSeriesColumnContent_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.attribute_ IS NOT NULL) THEN
      json_.put('attribute', rec_.attribute_);
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Attribute (
   rec_   IN OUT NOCOPY RadarchartSeriesColumnContent_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.attribute_ := value_;
END Set_Attribute;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY RadarchartSeriesColumnContent_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY RadarchartSeriesColumnContent_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY RadarchartSeriesColumnContent_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;

FUNCTION Build (
   rec_   IN Ganttchart_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Ganttchart_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Ganttchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY Ganttchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Ganttchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Ganttchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Ganttchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY Ganttchart_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY Ganttchart_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;

FUNCTION Build (
   rec_   IN GanttchartElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'ganttchart');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('ganttchart', rec_.ganttchart_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY GanttchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY GanttchartElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY GanttchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Ganttchart (
   rec_   IN OUT NOCOPY GanttchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.ganttchart_ := value_;
END Set_Ganttchart;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY GanttchartElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN GanttchartItem_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartItem_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY GanttchartItem_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY GanttchartItem_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY GanttchartItem_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY GanttchartItem_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY GanttchartItem_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartItem_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY GanttchartItem_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;

FUNCTION Build (
   rec_   IN GanttchartItemElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartItemElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'ganttchartitem');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('ganttchartitem', rec_.ganttchartitem_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY GanttchartItemElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY GanttchartItemElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY GanttchartItemElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Ganttchartitem (
   rec_   IN OUT NOCOPY GanttchartItemElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.ganttchartitem_ := value_;
END Set_Ganttchartitem;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartItemElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY GanttchartItemElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN GanttchartRow_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartRow_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY GanttchartRow_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY GanttchartRow_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY GanttchartRow_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY GanttchartRow_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY GanttchartRow_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartRow_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY GanttchartRow_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;

FUNCTION Build (
   rec_   IN GanttchartRowElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartRowElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'ganttchartrow');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('ganttchartrow', rec_.ganttchartrow_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY GanttchartRowElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY GanttchartRowElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY GanttchartRowElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Ganttchartrow (
   rec_   IN OUT NOCOPY GanttchartRowElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.ganttchartrow_ := value_;
END Set_Ganttchartrow;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartRowElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY GanttchartRowElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN GanttchartItemStyle_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartItemStyle_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY GanttchartItemStyle_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY GanttchartItemStyle_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY GanttchartItemStyle_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY GanttchartItemStyle_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY GanttchartItemStyle_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartItemStyle_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY GanttchartItemStyle_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;

FUNCTION Build (
   rec_   IN GanttchartItemStyleElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartItemStyleElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'ganttchartitemstyle');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('ganttchartitemstyle', rec_.ganttchartitemstyle_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY GanttchartItemStyleElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY GanttchartItemStyleElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY GanttchartItemStyleElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Ganttchartitemstyle (
   rec_   IN OUT NOCOPY GanttchartItemStyleElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.ganttchartitemstyle_ := value_;
END Set_Ganttchartitemstyle;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartItemStyleElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY GanttchartItemStyleElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN GanttchartRowIcon_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartRowIcon_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY GanttchartRowIcon_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY GanttchartRowIcon_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY GanttchartRowIcon_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY GanttchartRowIcon_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY GanttchartRowIcon_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartRowIcon_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY GanttchartRowIcon_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;

FUNCTION Build (
   rec_   IN GanttchartRowIconElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartRowIconElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'ganttchartrowicon');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('ganttchartrowicon', rec_.ganttchartrowicon_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY GanttchartRowIconElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY GanttchartRowIconElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY GanttchartRowIconElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Ganttchartrowicon (
   rec_   IN OUT NOCOPY GanttchartRowIconElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.ganttchartrowicon_ := value_;
END Set_Ganttchartrowicon;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartRowIconElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY GanttchartRowIconElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN GanttDependency_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttDependency_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY GanttDependency_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY GanttDependency_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY GanttDependency_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY GanttDependency_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY GanttDependency_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttDependency_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY GanttDependency_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;

FUNCTION Build (
   rec_   IN GanttDependencyElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttDependencyElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'ganttdependency');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('ganttdependency', rec_.ganttdependency_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY GanttDependencyElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY GanttDependencyElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY GanttDependencyElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Ganttdependency (
   rec_   IN OUT NOCOPY GanttDependencyElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.ganttdependency_ := value_;
END Set_Ganttdependency;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttDependencyElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY GanttDependencyElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN GanttchartTimemarker_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartTimemarker_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY GanttchartTimemarker_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY GanttchartTimemarker_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY GanttchartTimemarker_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY GanttchartTimemarker_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY GanttchartTimemarker_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartTimemarker_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY GanttchartTimemarker_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;

FUNCTION Build (
   rec_   IN GanttchartTimemarkerElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartTimemarkerElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'ganttcharttimemarker');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('ganttcharttimemarker', rec_.ganttcharttimemarker_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY GanttchartTimemarkerElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY GanttchartTimemarkerElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY GanttchartTimemarkerElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Ganttcharttimemarker (
   rec_   IN OUT NOCOPY GanttchartTimemarkerElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.ganttcharttimemarker_ := value_;
END Set_Ganttcharttimemarker;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartTimemarkerElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY GanttchartTimemarkerElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN GanttchartSchedule_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartSchedule_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY GanttchartSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY GanttchartSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY GanttchartSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY GanttchartSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY GanttchartSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY GanttchartSchedule_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;

FUNCTION Build (
   rec_   IN GanttchartScheduleElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartScheduleElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'ganttchartschedule');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('ganttchartschedule', rec_.ganttchartschedule_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY GanttchartScheduleElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY GanttchartScheduleElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY GanttchartScheduleElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Ganttchartschedule (
   rec_   IN OUT NOCOPY GanttchartScheduleElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.ganttchartschedule_ := value_;
END Set_Ganttchartschedule;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartScheduleElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY GanttchartScheduleElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN GanttchartLegend_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartLegend_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY GanttchartLegend_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY GanttchartLegend_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY GanttchartLegend_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY GanttchartLegend_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY GanttchartLegend_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartLegend_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY GanttchartLegend_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;

FUNCTION Build (
   rec_   IN GanttchartLegendElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GanttchartLegendElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'ganttchartlegend');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('ganttchartlegend', rec_.ganttchartlegend_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY GanttchartLegendElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY GanttchartLegendElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY GanttchartLegendElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Ganttchartlegend (
   rec_   IN OUT NOCOPY GanttchartLegendElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.ganttchartlegend_ := value_;
END Set_Ganttchartlegend;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GanttchartLegendElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY GanttchartLegendElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN TreeView_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN TreeView_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.editmode_ IS NOT NULL) THEN
      json_.put('editmode', rec_.editmode_);
   END IF;
   IF (rec_.staticlabel_ IS NOT NULL) THEN
      json_.put('staticlabel', rec_.staticlabel_);
   END IF;
   IF (rec_.additionalcontext_ IS NOT NULL) THEN
      IF (rec_.additionalcontext_ IS NULL) THEN
         json_.put('additionalcontext', JSON_ARRAY_T());
      ELSE
         json_.put('additionalcontext', rec_.additionalcontext_);
      END IF;
   END IF;
   IF (rec_.crudactions_ IS NOT NULL) THEN
      IF (rec_.crudactions_ IS NULL) THEN
         json_.put('crudactions', JSON_OBJECT_T());
      ELSE
         json_.put('crudactions', rec_.crudactions_);
      END IF;
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.entity_ IS NOT NULL) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.searchcontext_ IS NOT NULL) THEN
      IF (rec_.searchcontext_ IS NULL) THEN
         json_.put('searchcontext', JSON_ARRAY_T());
      ELSE
         json_.put('searchcontext', rec_.searchcontext_);
      END IF;
   END IF;
   IF (rec_.ganttchart_ IS NOT NULL) THEN
      IF (rec_.ganttchart_ IS NULL) THEN
         json_.put('ganttchart', JSON_ARRAY_T());
      ELSE
         json_.put('ganttchart', rec_.ganttchart_);
      END IF;
   END IF;
   IF (rec_.defaultfilter_ IS NOT NULL) THEN
      json_.put('defaultfilter', rec_.defaultfilter_);
   END IF;
   IF (rec_.stateindicator_ IS NOT NULL) THEN
      json_.put('stateindicator', rec_.stateindicator_);
   END IF;
   IF (rec_.attachments_ IS NOT NULL) THEN
      IF (rec_.attachments_ IS NULL) THEN
         json_.put('attachments', JSON_OBJECT_T());
      ELSE
         json_.put('attachments', rec_.attachments_);
      END IF;
   END IF;
   IF (rec_.media_ IS NOT NULL) THEN
      IF (rec_.media_ IS NULL) THEN
         json_.put('media', JSON_OBJECT_T());
      ELSE
         json_.put('media', rec_.media_);
      END IF;
   END IF;
   IF (rec_.content_ IS NOT NULL) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   IF (rec_.commands_ IS NOT NULL) THEN
      IF (rec_.commands_ IS NULL) THEN
         json_.put('commands', JSON_ARRAY_T());
      ELSE
         json_.put('commands', rec_.commands_);
      END IF;
   END IF;
   IF (rec_.commandgroups_ IS NOT NULL) THEN
      IF (rec_.commandgroups_ IS NULL) THEN
         json_.put('commandgroups', JSON_ARRAY_T());
      ELSE
         json_.put('commandgroups', rec_.commandgroups_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('url', rec_.url_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.nodes_ IS NULL) THEN
         json_.put('nodes', JSON_ARRAY_T());
      ELSE
         json_.put('nodes', rec_.nodes_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Editmode (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.editmode_ := value_;
END Set_Editmode;
  
PROCEDURE Set_Staticlabel (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.staticlabel_ := value_;
END Set_Staticlabel;
  
PROCEDURE Add_Additionalcontext (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.additionalcontext_ IS NULL) THEN
      rec_.additionalcontext_ := JSON_ARRAY_T();
   END IF;
   rec_.additionalcontext_.append(value_);
END Add_Additionalcontext;
  

PROCEDURE Set_Crudactions (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            CrudActions_Rec )
IS
BEGIN
   rec_.crudactions_ := Build_Json___(value_);
END Set_Crudactions;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  

PROCEDURE Add_Searchcontext (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            SearchContext_Rec )
IS
BEGIN
   IF (rec_.searchcontext_ IS NULL) THEN
      rec_.searchcontext_ := JSON_ARRAY_T();
   END IF;
   rec_.searchcontext_.append(Build_Json___(value_));
END Add_Searchcontext;

  

PROCEDURE Add_Ganttchart (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            Ganttchart_Rec )
IS
BEGIN
   IF (rec_.ganttchart_ IS NULL) THEN
      rec_.ganttchart_ := JSON_ARRAY_T();
   END IF;
   rec_.ganttchart_.append(Build_Json___(value_));
END Add_Ganttchart;

  
PROCEDURE Set_Defaultfilter (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.defaultfilter_ := value_;
END Set_Defaultfilter;
  
PROCEDURE Set_Stateindicator (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.stateindicator_ := value_;
END Set_Stateindicator;
  

PROCEDURE Set_Attachments (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            Attachments_Rec )
IS
BEGIN
   rec_.attachments_ := Build_Json___(value_);
END Set_Attachments;

  

PROCEDURE Set_Media (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            Media_Rec )
IS
BEGIN
   rec_.media_ := Build_Json___(value_);
END Set_Media;

  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            PiechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            BarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            StackedchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            LinechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            RadarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            GanttchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            GanttchartItemElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            GanttchartRowElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            GanttchartItemStyleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            GanttchartRowIconElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            GanttDependencyElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            GanttchartTimemarkerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            GanttchartScheduleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            GanttchartLegendElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            BoxMatrixElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            CalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            CardElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            DiagramElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            FieldSetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            FileSelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            GroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            InlineGroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            ImageviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            ListElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            MarkdownTextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            PluginElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            ProcessviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            StackedCalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            SelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            SingletonElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            SheetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            SearchContextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            TimelineElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            YearViewElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            Arrange_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            TabsElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;

  
PROCEDURE Add_Commands (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.commands_ IS NULL) THEN
      rec_.commands_ := JSON_ARRAY_T();
   END IF;
   rec_.commands_.append(value_);
END Add_Commands;
  

PROCEDURE Add_Commandgroups (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            CommandGroup_Rec )
IS
BEGIN
   IF (rec_.commandgroups_ IS NULL) THEN
      rec_.commandgroups_ := JSON_ARRAY_T();
   END IF;
   rec_.commandgroups_.append(Build_Json___(value_));
END Add_Commandgroups;

  
PROCEDURE Set_Url (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.url_ := value_;
END Set_Url;
  

PROCEDURE Add_Nodes (
   rec_   IN OUT NOCOPY TreeView_Rec,
   value_ IN            TreeViewNode_Rec )
IS
BEGIN
   IF (rec_.nodes_ IS NULL) THEN
      rec_.nodes_ := JSON_ARRAY_T();
   END IF;
   rec_.nodes_.append(Build_Json___(value_));
END Add_Nodes;


FUNCTION Build (
   rec_   IN TreeViewNode_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN TreeViewNode_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.node_ IS NULL) THEN
         json_.put('node', JSON_OBJECT_T());
      ELSE
         json_.put('node', rec_.node_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Node (
   rec_   IN OUT NOCOPY TreeViewNode_Rec,
   value_ IN            TreeNode_Rec )
IS
BEGIN
   rec_.node_ := Build_Json___(value_);
END Set_Node;


FUNCTION Build (
   rec_   IN TreeNode_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN TreeNode_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.root_ IS NOT NULL) THEN
      json_.put('root', rec_.root_);
   END IF;
   IF (rec_.entity_ IS NOT NULL) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.url_ IS NOT NULL) THEN
      json_.put('url', rec_.url_);
   END IF;
   IF (rec_.iconset_ IS NOT NULL) THEN
      IF (rec_.iconset_ IS NULL) THEN
         json_.put('iconset', JSON_ARRAY_T());
      ELSE
         json_.put('iconset', rec_.iconset_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.navigate_ IS NULL) THEN
         json_.put('navigate', JSON_ARRAY_T());
      ELSE
         json_.put('navigate', rec_.navigate_);
      END IF;
   END IF;
   IF (rec_.connections_ IS NOT NULL) THEN
      IF (rec_.connections_ IS NULL) THEN
         json_.put('connections', JSON_ARRAY_T());
      ELSE
         json_.put('connections', rec_.connections_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY TreeNode_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Root (
   rec_   IN OUT NOCOPY TreeNode_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.root_ := value_;
END Set_Root;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY TreeNode_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY TreeNode_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Url (
   rec_   IN OUT NOCOPY TreeNode_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.url_ := value_;
END Set_Url;
  

PROCEDURE Add_Iconset (
   rec_   IN OUT NOCOPY TreeNode_Rec,
   value_ IN            TreeNodeIcon_Rec )
IS
BEGIN
   IF (rec_.iconset_ IS NULL) THEN
      rec_.iconset_ := JSON_ARRAY_T();
   END IF;
   rec_.iconset_.append(Build_Json___(value_));
END Add_Iconset;

  

PROCEDURE Add_Navigate (
   rec_   IN OUT NOCOPY TreeNode_Rec,
   value_ IN            TreeNodeNavigation_Rec )
IS
BEGIN
   IF (rec_.navigate_ IS NULL) THEN
      rec_.navigate_ := JSON_ARRAY_T();
   END IF;
   rec_.navigate_.append(Build_Json___(value_));
END Add_Navigate;

  

PROCEDURE Add_Connections (
   rec_   IN OUT NOCOPY TreeNode_Rec,
   value_ IN            TreeNodeConnection_Rec )
IS
BEGIN
   IF (rec_.connections_ IS NULL) THEN
      rec_.connections_ := JSON_ARRAY_T();
   END IF;
   rec_.connections_.append(Build_Json___(value_));
END Add_Connections;


FUNCTION Build (
   rec_   IN TreeNodeIcon_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN TreeNodeIcon_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.icon_ IS NULL) THEN
         json_.put('icon', JSON_OBJECT_T());
      ELSE
         json_.put('icon', rec_.icon_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Icon (
   rec_   IN OUT NOCOPY TreeNodeIcon_Rec,
   value_ IN            TreeNodeIconDetails_Rec )
IS
BEGIN
   rec_.icon_ := Build_Json___(value_);
END Set_Icon;


FUNCTION Build (
   rec_   IN TreeNodeIconDetails_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN TreeNodeIconDetails_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('expresssion', rec_.expresssion_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY TreeNodeIconDetails_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Expresssion (
   rec_   IN OUT NOCOPY TreeNodeIconDetails_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.expresssion_ := value_;
END Set_Expresssion;

FUNCTION Build (
   rec_   IN TreeNodeNavigation_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN TreeNodeNavigation_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('url', rec_.url_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.expression_ = 'TRUE') THEN
         json_.put('expression', TRUE);
      ELSIF (rec_.expression_ = 'FALSE') THEN
         json_.put('expression', FALSE);
      ELSE
         json_.put('expression', rec_.expression_);
      END IF;
   END IF;
   IF (rec_.default_ IS NOT NULL) THEN
      json_.put('default', rec_.default_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Url (
   rec_   IN OUT NOCOPY TreeNodeNavigation_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.url_ := value_;
END Set_Url;
  
PROCEDURE Set_Expression (
   rec_   IN OUT NOCOPY TreeNodeNavigation_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.expression_ := value_;
END Set_Expression;


PROCEDURE Set_Expression (
   rec_   IN OUT NOCOPY TreeNodeNavigation_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.expression_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Expression;
  
PROCEDURE Set_Default (
   rec_   IN OUT NOCOPY TreeNodeNavigation_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.default_ := value_;
END Set_Default;

FUNCTION Build (
   rec_   IN TreeNodeConnection_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN TreeNodeConnection_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.connection_ IS NULL) THEN
         json_.put('connection', JSON_OBJECT_T());
      ELSE
         json_.put('connection', rec_.connection_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Connection (
   rec_   IN OUT NOCOPY TreeNodeConnection_Rec,
   value_ IN            TreeNodeConnectionType_Rec )
IS
BEGIN
   rec_.connection_ := Build_Json___(value_);
END Set_Connection;


FUNCTION Build (
   rec_   IN TreeNodeConnectionType_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN TreeNodeConnectionType_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('type', rec_.type_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Type (
   rec_   IN OUT NOCOPY TreeNodeConnectionType_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.type_ := value_;
END Set_Type;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY TreeNodeConnectionType_Rec,
   value_ IN            TreeNodeConnectionBinding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN TreeNodeConnectionBinding_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN TreeNodeConnectionBinding_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('bindname', rec_.bindname_);
   END IF;
   IF (TRUE) THEN
      json_.put('property', rec_.property_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Bindname (
   rec_   IN OUT NOCOPY TreeNodeConnectionBinding_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.bindname_ := value_;
END Set_Bindname;
  
PROCEDURE Set_Property (
   rec_   IN OUT NOCOPY TreeNodeConnectionBinding_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.property_ := value_;
END Set_Property;

FUNCTION Build (
   rec_   IN Assistant_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Assistant_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.staticlabel_ IS NOT NULL) THEN
      json_.put('staticlabel', rec_.staticlabel_);
   END IF;
   IF (rec_.additionalcontext_ IS NOT NULL) THEN
      IF (rec_.additionalcontext_ IS NULL) THEN
         json_.put('additionalcontext', JSON_ARRAY_T());
      ELSE
         json_.put('additionalcontext', rec_.additionalcontext_);
      END IF;
   END IF;
   IF (rec_.savemode_ IS NOT NULL) THEN
      json_.put('savemode', rec_.savemode_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.structure_ IS NOT NULL) THEN
      json_.put('structure', rec_.structure_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.auto_restart_ IS NOT NULL) THEN
      IF (rec_.auto_restart_ = 'TRUE') THEN
         json_.put('autoRestart', TRUE);
      ELSIF (rec_.auto_restart_ = 'FALSE') THEN
         json_.put('autoRestart', FALSE);
      ELSE
         json_.put('autoRestart', rec_.auto_restart_);
      END IF;
   END IF;
   IF (rec_.setups_ IS NOT NULL) THEN
      IF (rec_.setups_ IS NULL) THEN
         json_.put('setups', JSON_OBJECT_T());
      ELSE
         json_.put('setups', rec_.setups_);
      END IF;
   END IF;
   IF (rec_.init_command_ IS NOT NULL) THEN
      IF (rec_.init_command_ IS NULL) THEN
         json_.put('initCommand', JSON_OBJECT_T());
      ELSE
         json_.put('initCommand', rec_.init_command_);
      END IF;
   END IF;
   IF (rec_.back_command_ IS NOT NULL) THEN
      IF (rec_.back_command_ IS NULL) THEN
         json_.put('backCommand', JSON_OBJECT_T());
      ELSE
         json_.put('backCommand', rec_.back_command_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.steps_ IS NULL) THEN
         json_.put('steps', JSON_ARRAY_T());
      ELSE
         json_.put('steps', rec_.steps_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.final_ IS NULL) THEN
         json_.put('final', JSON_OBJECT_T());
      ELSE
         json_.put('final', rec_.final_);
      END IF;
   END IF;
   IF (rec_.cancel_ IS NOT NULL) THEN
      IF (rec_.cancel_ IS NULL) THEN
         json_.put('cancel', JSON_OBJECT_T());
      ELSE
         json_.put('cancel', rec_.cancel_);
      END IF;
   END IF;
   IF (rec_.finish_command_ IS NOT NULL) THEN
      IF (rec_.finish_command_ IS NULL) THEN
         json_.put('finishCommand', JSON_OBJECT_T());
      ELSE
         json_.put('finishCommand', rec_.finish_command_);
      END IF;
   END IF;
   IF (rec_.cancel_command_ IS NOT NULL) THEN
      IF (rec_.cancel_command_ IS NULL) THEN
         json_.put('cancelCommand', JSON_OBJECT_T());
      ELSE
         json_.put('cancelCommand', rec_.cancel_command_);
      END IF;
   END IF;
   IF (rec_.restart_command_ IS NOT NULL) THEN
      IF (rec_.restart_command_ IS NULL) THEN
         json_.put('restartCommand', JSON_OBJECT_T());
      ELSE
         json_.put('restartCommand', rec_.restart_command_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Staticlabel (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.staticlabel_ := value_;
END Set_Staticlabel;
  
PROCEDURE Add_Additionalcontext (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.additionalcontext_ IS NULL) THEN
      rec_.additionalcontext_ := JSON_ARRAY_T();
   END IF;
   rec_.additionalcontext_.append(value_);
END Add_Additionalcontext;
  
PROCEDURE Set_Savemode (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.savemode_ := value_;
END Set_Savemode;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Structure (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.structure_ := value_;
END Set_Structure;

  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Auto_Restart (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.auto_restart_ := value_;
END Set_Auto_Restart;


PROCEDURE Set_Auto_Restart (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.auto_restart_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Auto_Restart;
  

PROCEDURE Add_Setups (
   rec_   IN OUT NOCOPY Assistant_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Command_Rec )
IS
BEGIN
   IF (rec_.setups_ IS NULL) THEN
      rec_.setups_ := JSON_OBJECT_T();
   END IF;
   rec_.setups_.put(name_, Build_Json___(value_));
END Add_Setups;

  

PROCEDURE Set_Init_Command (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.init_command_ := Build_Json___(value_);
END Set_Init_Command;

  

PROCEDURE Set_Back_Command (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.back_command_ := Build_Json___(value_);
END Set_Back_Command;

  

PROCEDURE Add_Steps (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            Step_Rec )
IS
BEGIN
   IF (rec_.steps_ IS NULL) THEN
      rec_.steps_ := JSON_ARRAY_T();
   END IF;
   rec_.steps_.append(Build_Json___(value_));
END Add_Steps;

  

PROCEDURE Set_Final (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            Step_Rec )
IS
BEGIN
   rec_.final_ := Build_Json___(value_);
END Set_Final;

  

PROCEDURE Set_Cancel (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            Step_Rec )
IS
BEGIN
   rec_.cancel_ := Build_Json___(value_);
END Set_Cancel;

  

PROCEDURE Set_Finish_Command (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.finish_command_ := Build_Json___(value_);
END Set_Finish_Command;

  

PROCEDURE Set_Cancel_Command (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.cancel_command_ := Build_Json___(value_);
END Set_Cancel_Command;

  

PROCEDURE Set_Restart_Command (
   rec_   IN OUT NOCOPY Assistant_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.restart_command_ := Build_Json___(value_);
END Set_Restart_Command;


FUNCTION Build (
   rec_   IN Step_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Step_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.name_ IS NOT NULL) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.showlabel_ IS NOT NULL) THEN
      json_.put('showlabel', rec_.showlabel_);
   END IF;
   IF (rec_.description_ IS NOT NULL) THEN
      json_.put('description', rec_.description_);
   END IF;
   IF (rec_.skipattribute_ IS NOT NULL) THEN
      json_.put('skipattribute', rec_.skipattribute_);
   END IF;
   IF (rec_.enabled_ IS NOT NULL) THEN
      IF (rec_.enabled_ = 'TRUE') THEN
         json_.put('enabled', TRUE);
      ELSIF (rec_.enabled_ = 'FALSE') THEN
         json_.put('enabled', FALSE);
      ELSE
         json_.put('enabled', rec_.enabled_);
      END IF;
   END IF;
   IF (rec_.optional_ IS NOT NULL) THEN
      IF (rec_.optional_ = 'TRUE') THEN
         json_.put('optional', TRUE);
      ELSIF (rec_.optional_ = 'FALSE') THEN
         json_.put('optional', FALSE);
      ELSE
         json_.put('optional', rec_.optional_);
      END IF;
   END IF;
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   IF (rec_.valid_ IS NOT NULL) THEN
      IF (rec_.valid_ = 'TRUE') THEN
         json_.put('valid', TRUE);
      ELSIF (rec_.valid_ = 'FALSE') THEN
         json_.put('valid', FALSE);
      ELSE
         json_.put('valid', rec_.valid_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   IF (rec_.next_command_ IS NOT NULL) THEN
      IF (rec_.next_command_ IS NULL) THEN
         json_.put('nextCommand', JSON_OBJECT_T());
      ELSE
         json_.put('nextCommand', rec_.next_command_);
      END IF;
   END IF;
   IF (rec_.skip_command_ IS NOT NULL) THEN
      IF (rec_.skip_command_ IS NULL) THEN
         json_.put('skipCommand', JSON_OBJECT_T());
      ELSE
         json_.put('skipCommand', rec_.skip_command_);
      END IF;
   END IF;
   IF (rec_.commands_ IS NOT NULL) THEN
      IF (rec_.commands_ IS NULL) THEN
         json_.put('commands', JSON_ARRAY_T());
      ELSE
         json_.put('commands', rec_.commands_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Showlabel (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.showlabel_ := value_;
END Set_Showlabel;
  
PROCEDURE Set_Description (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.description_ := value_;
END Set_Description;
  
PROCEDURE Set_Skipattribute (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.skipattribute_ := value_;
END Set_Skipattribute;
  
PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.enabled_ := value_;
END Set_Enabled;


PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.enabled_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Enabled;
  
PROCEDURE Set_Optional (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.optional_ := value_;
END Set_Optional;


PROCEDURE Set_Optional (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.optional_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Optional;
  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;
  
PROCEDURE Set_Valid (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.valid_ := value_;
END Set_Valid;


PROCEDURE Set_Valid (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.valid_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Valid;
  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            PiechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            BarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            StackedchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            LinechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            RadarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            GanttchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            GanttchartItemElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            GanttchartRowElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            GanttchartItemStyleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            GanttchartRowIconElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            GanttDependencyElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            GanttchartTimemarkerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            GanttchartScheduleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            GanttchartLegendElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            BoxMatrixElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            CalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            CardElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            DiagramElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            FieldSetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            FileSelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            GroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            InlineGroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            ImageviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            ListElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            MarkdownTextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            PluginElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            ProcessviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            StackedCalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            SelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            SingletonElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            SheetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            SearchContextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            TimelineElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            YearViewElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            Arrange_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            TabsElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;

  

PROCEDURE Set_Next_Command (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.next_command_ := Build_Json___(value_);
END Set_Next_Command;

  

PROCEDURE Set_Skip_Command (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.skip_command_ := Build_Json___(value_);
END Set_Skip_Command;

  
PROCEDURE Add_Commands (
   rec_   IN OUT NOCOPY Step_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.commands_ IS NULL) THEN
      rec_.commands_ := JSON_ARRAY_T();
   END IF;
   rec_.commands_.append(value_);
END Add_Commands;

FUNCTION Build (
   rec_   IN BoxMatrix_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BoxMatrix_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.card_ IS NOT NULL) THEN
      json_.put('card', rec_.card_);
   END IF;
   IF (rec_.boximage_ IS NOT NULL) THEN
      IF (rec_.boximage_ IS NULL) THEN
         json_.put('boximage', JSON_OBJECT_T());
      ELSE
         json_.put('boximage', rec_.boximage_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('boxvalue', rec_.boxvalue_);
   END IF;
   IF (rec_.boxtitle_ IS NOT NULL) THEN
      json_.put('boxtitle', rec_.boxtitle_);
   END IF;
   IF (TRUE) THEN
      json_.put('description', rec_.description_);
   END IF;
   IF (rec_.initialview_ IS NOT NULL) THEN
      json_.put('initialview', rec_.initialview_);
   END IF;
   IF (rec_.count_ IS NOT NULL) THEN
      IF (rec_.count_ = 'TRUE') THEN
         json_.put('count', TRUE);
      ELSIF (rec_.count_ = 'FALSE') THEN
         json_.put('count', FALSE);
      ELSE
         json_.put('count', rec_.count_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.xaxis_ IS NULL) THEN
         json_.put('xaxis', JSON_OBJECT_T());
      ELSE
         json_.put('xaxis', rec_.xaxis_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.yaxis_ IS NULL) THEN
         json_.put('yaxis', JSON_OBJECT_T());
      ELSE
         json_.put('yaxis', rec_.yaxis_);
      END IF;
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY BoxMatrix_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY BoxMatrix_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  

PROCEDURE Set_Card (
   rec_   IN OUT NOCOPY BoxMatrix_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.card_ := value_;
END Set_Card;

  

PROCEDURE Set_Boximage (
   rec_   IN OUT NOCOPY BoxMatrix_Rec,
   value_ IN            BoxMatrixImage_Rec )
IS
BEGIN
   rec_.boximage_ := Build_Json___(value_);
END Set_Boximage;

  
PROCEDURE Set_Boxvalue (
   rec_   IN OUT NOCOPY BoxMatrix_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.boxvalue_ := value_;
END Set_Boxvalue;
  
PROCEDURE Set_Boxtitle (
   rec_   IN OUT NOCOPY BoxMatrix_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.boxtitle_ := value_;
END Set_Boxtitle;
  
PROCEDURE Set_Description (
   rec_   IN OUT NOCOPY BoxMatrix_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.description_ := value_;
END Set_Description;
  
PROCEDURE Set_Initialview (
   rec_   IN OUT NOCOPY BoxMatrix_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.initialview_ := value_;
END Set_Initialview;
  
PROCEDURE Set_Count (
   rec_   IN OUT NOCOPY BoxMatrix_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.count_ := value_;
END Set_Count;


PROCEDURE Set_Count (
   rec_   IN OUT NOCOPY BoxMatrix_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.count_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Count;
  

PROCEDURE Set_Xaxis (
   rec_   IN OUT NOCOPY BoxMatrix_Rec,
   value_ IN            BoxMatrixAxis_Rec )
IS
BEGIN
   rec_.xaxis_ := Build_Json___(value_);
END Set_Xaxis;

  

PROCEDURE Set_Yaxis (
   rec_   IN OUT NOCOPY BoxMatrix_Rec,
   value_ IN            BoxMatrixAxis_Rec )
IS
BEGIN
   rec_.yaxis_ := Build_Json___(value_);
END Set_Yaxis;

  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY BoxMatrix_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;


FUNCTION Build (
   rec_   IN BoxMatrixAxis_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BoxMatrixAxis_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('attribute', rec_.attribute_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (TRUE) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('map', rec_.map_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY BoxMatrixAxis_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Set_Attribute (
   rec_   IN OUT NOCOPY BoxMatrixAxis_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.attribute_ := value_;
END Set_Attribute;

  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY BoxMatrixAxis_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY BoxMatrixAxis_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY BoxMatrixAxis_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;
  
PROCEDURE Set_Map (
   rec_   IN OUT NOCOPY BoxMatrixAxis_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.map_ := value_;
END Set_Map;

FUNCTION Build (
   rec_   IN BoxMatrixImage_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BoxMatrixImage_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('attribute', rec_.attribute_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY BoxMatrixImage_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Set_Attribute (
   rec_   IN OUT NOCOPY BoxMatrixImage_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.attribute_ := value_;
END Set_Attribute;

  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY BoxMatrixImage_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;

FUNCTION Build (
   rec_   IN BoxMatrixElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BoxMatrixElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'boxMatrix');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('boxMatrix', rec_.box_matrix_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY BoxMatrixElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY BoxMatrixElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY BoxMatrixElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Box_Matrix (
   rec_   IN OUT NOCOPY BoxMatrixElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.box_matrix_ := value_;
END Set_Box_Matrix;


FUNCTION Build (
   rec_   IN Calendar_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Calendar_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.slot_tick_ IS NOT NULL) THEN
      json_.put('slotTick', rec_.slot_tick_);
   END IF;
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   IF (rec_.schedule_ IS NOT NULL) THEN
      IF (rec_.schedule_ IS NULL) THEN
         json_.put('schedule', JSON_OBJECT_T());
      ELSE
         json_.put('schedule', rec_.schedule_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.resources_ IS NULL) THEN
         json_.put('resources', JSON_OBJECT_T());
      ELSE
         json_.put('resources', rec_.resources_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('orientation', rec_.orientation_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.grouping_ IS NULL) THEN
         json_.put('grouping', JSON_OBJECT_T());
      ELSE
         json_.put('grouping', rec_.grouping_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.events_ IS NULL) THEN
         json_.put('events', JSON_OBJECT_T());
      ELSE
         json_.put('events', rec_.events_);
      END IF;
   END IF;
   IF (rec_.commands_ IS NOT NULL) THEN
      IF (rec_.commands_ IS NULL) THEN
         json_.put('commands', JSON_ARRAY_T());
      ELSE
         json_.put('commands', rec_.commands_);
      END IF;
   END IF;
   IF (rec_.commandgroups_ IS NOT NULL) THEN
      IF (rec_.commandgroups_ IS NULL) THEN
         json_.put('commandgroups', JSON_ARRAY_T());
      ELSE
         json_.put('commandgroups', rec_.commandgroups_);
      END IF;
   END IF;
   IF (rec_.create_ IS NOT NULL) THEN
      IF (rec_.create_ IS NULL) THEN
         json_.put('create', JSON_OBJECT_T());
      ELSE
         json_.put('create', rec_.create_);
      END IF;
   END IF;
   IF (rec_.edit_ IS NOT NULL) THEN
      IF (rec_.edit_ IS NULL) THEN
         json_.put('edit', JSON_OBJECT_T());
      ELSE
         json_.put('edit', rec_.edit_);
      END IF;
   END IF;
   IF (rec_.delete_ IS NOT NULL) THEN
      IF (rec_.delete_ IS NULL) THEN
         json_.put('delete', JSON_OBJECT_T());
      ELSE
         json_.put('delete', rec_.delete_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  

PROCEDURE Set_Slot_Tick (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            INTEGER )
IS
BEGIN
   rec_.slot_tick_ := value_;
END Set_Slot_Tick;

  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;
  

PROCEDURE Set_Schedule (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            CalendarSchedule_Rec )
IS
BEGIN
   rec_.schedule_ := Build_Json___(value_);
END Set_Schedule;

  

PROCEDURE Add_Resources (
   rec_   IN OUT NOCOPY Calendar_Rec,
   name_  IN            VARCHAR2,
   value_ IN            CalendarResource_Rec )
IS
BEGIN
   IF (rec_.resources_ IS NULL) THEN
      rec_.resources_ := JSON_OBJECT_T();
   END IF;
   rec_.resources_.put(name_, Build_Json___(value_));
END Add_Resources;

  
PROCEDURE Set_Orientation (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.orientation_ := value_;
END Set_Orientation;
  

PROCEDURE Add_Grouping (
   rec_   IN OUT NOCOPY Calendar_Rec,
   name_  IN            VARCHAR2,
   value_ IN            CalendarGrouping_Rec )
IS
BEGIN
   IF (rec_.grouping_ IS NULL) THEN
      rec_.grouping_ := JSON_OBJECT_T();
   END IF;
   rec_.grouping_.put(name_, Build_Json___(value_));
END Add_Grouping;

  

PROCEDURE Set_Events (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            CalendarEvent_Rec )
IS
BEGIN
   rec_.events_ := Build_Json___(value_);
END Set_Events;

  
PROCEDURE Add_Commands (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.commands_ IS NULL) THEN
      rec_.commands_ := JSON_ARRAY_T();
   END IF;
   rec_.commands_.append(value_);
END Add_Commands;
  

PROCEDURE Add_Commandgroups (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            CommandGroup_Rec )
IS
BEGIN
   IF (rec_.commandgroups_ IS NULL) THEN
      rec_.commandgroups_ := JSON_ARRAY_T();
   END IF;
   rec_.commandgroups_.append(Build_Json___(value_));
END Add_Commandgroups;

  

PROCEDURE Set_Create (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.create_ := Build_Json___(value_);
END Set_Create;

  

PROCEDURE Set_Edit (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.edit_ := Build_Json___(value_);
END Set_Edit;

  

PROCEDURE Set_Delete (
   rec_   IN OUT NOCOPY Calendar_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.delete_ := Build_Json___(value_);
END Set_Delete;


FUNCTION Build (
   rec_   IN CalendarSchedule_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CalendarSchedule_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.entity_ IS NOT NULL) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.workdaystart_ IS NOT NULL) THEN
      json_.put('workdaystart', rec_.workdaystart_);
   END IF;
   IF (rec_.workdayend_ IS NOT NULL) THEN
      json_.put('workdayend', rec_.workdayend_);
   END IF;
   IF (rec_.weekstart_ IS NOT NULL) THEN
      json_.put('weekstart', rec_.weekstart_);
   END IF;
   IF (rec_.yearstart_ IS NOT NULL) THEN
      json_.put('yearstart', rec_.yearstart_);
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY CalendarSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Workdaystart (
   rec_   IN OUT NOCOPY CalendarSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.workdaystart_ := value_;
END Set_Workdaystart;
  
PROCEDURE Set_Workdayend (
   rec_   IN OUT NOCOPY CalendarSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.workdayend_ := value_;
END Set_Workdayend;
  
PROCEDURE Set_Weekstart (
   rec_   IN OUT NOCOPY CalendarSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.weekstart_ := value_;
END Set_Weekstart;
  
PROCEDURE Set_Yearstart (
   rec_   IN OUT NOCOPY CalendarSchedule_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.yearstart_ := value_;
END Set_Yearstart;

FUNCTION Build (
   rec_   IN CalendarResource_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CalendarResource_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.filter_ IS NOT NULL) THEN
      json_.put('filter', rec_.filter_);
   END IF;
   IF (rec_.ranking_ IS NOT NULL) THEN
      json_.put('ranking', rec_.ranking_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY CalendarResource_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY CalendarResource_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Filter (
   rec_   IN OUT NOCOPY CalendarResource_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.filter_ := value_;
END Set_Filter;
  
PROCEDURE Set_Ranking (
   rec_   IN OUT NOCOPY CalendarResource_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.ranking_ := value_;
END Set_Ranking;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY CalendarResource_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;

FUNCTION Build (
   rec_   IN CalendarGrouping_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CalendarGrouping_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.ranking_ IS NOT NULL) THEN
      json_.put('ranking', rec_.ranking_);
   END IF;
   IF (rec_.contact_widget_ IS NOT NULL) THEN
      IF (rec_.contact_widget_ IS NULL) THEN
         json_.put('contactWidget', JSON_OBJECT_T());
      ELSE
         json_.put('contactWidget', rec_.contact_widget_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY CalendarGrouping_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY CalendarGrouping_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Ranking (
   rec_   IN OUT NOCOPY CalendarGrouping_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.ranking_ := value_;
END Set_Ranking;
  

PROCEDURE Set_Contact_Widget (
   rec_   IN OUT NOCOPY CalendarGrouping_Rec,
   value_ IN            ContactWidget_Rec )
IS
BEGIN
   rec_.contact_widget_ := Build_Json___(value_);
END Set_Contact_Widget;


FUNCTION Build (
   rec_   IN CalendarEvent_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CalendarEvent_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.card_ IS NOT NULL) THEN
      json_.put('card', rec_.card_);
   END IF;
   IF (rec_.allday_ IS NOT NULL) THEN
      IF (rec_.allday_ = 'TRUE') THEN
         json_.put('allday', TRUE);
      ELSIF (rec_.allday_ = 'FALSE') THEN
         json_.put('allday', FALSE);
      ELSE
         json_.put('allday', rec_.allday_);
      END IF;
   END IF;
   IF (rec_.keys_ IS NOT NULL) THEN
      IF (rec_.keys_ IS NULL) THEN
         json_.put('keys', JSON_ARRAY_T());
      ELSE
         json_.put('keys', rec_.keys_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('start', rec_.start_);
   END IF;
   IF (TRUE) THEN
      json_.put('end', rec_.end_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.views_ IS NULL) THEN
         json_.put('views', JSON_OBJECT_T());
      ELSE
         json_.put('views', rec_.views_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Card (
   rec_   IN OUT NOCOPY CalendarEvent_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.card_ := value_;
END Set_Card;

  
PROCEDURE Set_Allday (
   rec_   IN OUT NOCOPY CalendarEvent_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.allday_ := value_;
END Set_Allday;


PROCEDURE Set_Allday (
   rec_   IN OUT NOCOPY CalendarEvent_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.allday_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Allday;
  
PROCEDURE Add_Keys (
   rec_   IN OUT NOCOPY CalendarEvent_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.keys_ IS NULL) THEN
      rec_.keys_ := JSON_ARRAY_T();
   END IF;
   rec_.keys_.append(value_);
END Add_Keys;
  
PROCEDURE Set_Start (
   rec_   IN OUT NOCOPY CalendarEvent_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.start_ := value_;
END Set_Start;
  
PROCEDURE Set_End (
   rec_   IN OUT NOCOPY CalendarEvent_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.end_ := value_;
END Set_End;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY CalendarEvent_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;
  

PROCEDURE Add_Views (
   rec_   IN OUT NOCOPY CalendarEvent_Rec,
   name_  IN            VARCHAR2,
   value_ IN            CalendarView_Rec )
IS
BEGIN
   IF (rec_.views_ IS NULL) THEN
      rec_.views_ := JSON_OBJECT_T();
   END IF;
   rec_.views_.put(name_, Build_Json___(value_));
END Add_Views;


FUNCTION Build (
   rec_   IN CalendarView_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CalendarView_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.showlabel_ IS NOT NULL) THEN
      json_.put('showlabel', rec_.showlabel_);
   END IF;
   IF (rec_.all_day_label_ IS NOT NULL) THEN
      json_.put('allDayLabel', rec_.all_day_label_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   IF (rec_.timemarker_ IS NOT NULL) THEN
      json_.put('timemarker', rec_.timemarker_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY CalendarView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY CalendarView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Showlabel (
   rec_   IN OUT NOCOPY CalendarView_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.showlabel_ := value_;
END Set_Showlabel;
  
PROCEDURE Set_All_Day_Label (
   rec_   IN OUT NOCOPY CalendarView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.all_day_label_ := value_;
END Set_All_Day_Label;
  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY CalendarView_Rec,
   value_ IN            CalendarContentRow_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;

  
PROCEDURE Set_Timemarker (
   rec_   IN OUT NOCOPY CalendarView_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.timemarker_ := value_;
END Set_Timemarker;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY CalendarView_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;

FUNCTION Build (
   rec_   IN CalendarContentRow_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CalendarContentRow_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'field');
   END IF;
   IF (TRUE) THEN
      NULL;
   END IF;
   IF (TRUE) THEN
      IF (rec_.field_ IS NULL) THEN
         json_.put('field', JSON_OBJECT_T());
      ELSE
         json_.put('field', rec_.field_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY CalendarContentRow_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY CalendarContentRow_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Field (
   rec_   IN OUT NOCOPY CalendarContentRow_Rec,
   value_ IN            CalendarContentField_Rec )
IS
BEGIN
   rec_.field_ := Build_Json___(value_);
END Set_Field;


FUNCTION Build (
   rec_   IN CalendarContentField_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CalendarContentField_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('control', 'field');
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('datatype', rec_.datatype_);
   END IF;
   IF (rec_.enumeration_ IS NOT NULL) THEN
      json_.put('enumeration', rec_.enumeration_);
   END IF;
   IF (rec_.truelabel_ IS NOT NULL) THEN
      json_.put('truelabel', rec_.truelabel_);
   END IF;
   IF (rec_.falselabel_ IS NOT NULL) THEN
      json_.put('falselabel', rec_.falselabel_);
   END IF;
   IF (TRUE) THEN
      json_.put('attribute', rec_.attribute_);
   END IF;
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Control (
   rec_   IN OUT NOCOPY CalendarContentField_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.control_ := value_;
END Set_Control;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY CalendarContentField_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY CalendarContentField_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Datatype (
   rec_   IN OUT NOCOPY CalendarContentField_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datatype_ := value_;
END Set_Datatype;
  
PROCEDURE Set_Enumeration (
   rec_   IN OUT NOCOPY CalendarContentField_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.enumeration_ := value_;
END Set_Enumeration;
  
PROCEDURE Set_Truelabel (
   rec_   IN OUT NOCOPY CalendarContentField_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.truelabel_ := value_;
END Set_Truelabel;
  
PROCEDURE Set_Falselabel (
   rec_   IN OUT NOCOPY CalendarContentField_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.falselabel_ := value_;
END Set_Falselabel;
  

PROCEDURE Set_Attribute (
   rec_   IN OUT NOCOPY CalendarContentField_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.attribute_ := value_;
END Set_Attribute;

  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY CalendarContentField_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY CalendarContentField_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;

FUNCTION Build (
   rec_   IN CalendarElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CalendarElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'calendar');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('calendar', rec_.calendar_);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (rec_.override_ IS NOT NULL) THEN
      IF (rec_.override_ IS NULL) THEN
         json_.put('override', JSON_OBJECT_T());
      ELSE
         json_.put('override', rec_.override_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY CalendarElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY CalendarElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Calendar (
   rec_   IN OUT NOCOPY CalendarElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.calendar_ := value_;
END Set_Calendar;

  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY CalendarElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY CalendarElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY CalendarElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  

PROCEDURE Set_Override (
   rec_   IN OUT NOCOPY CalendarElement_Rec,
   value_ IN            CalendarElementOverride_Rec )
IS
BEGIN
   rec_.override_ := Build_Json___(value_);
END Set_Override;


FUNCTION Build (
   rec_   IN CalendarElementOverride_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CalendarElementOverride_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.details_ IS NOT NULL) THEN
      json_.put('details', rec_.details_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Details (
   rec_   IN OUT NOCOPY CalendarElementOverride_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.details_ := value_;
END Set_Details;

FUNCTION Build (
   rec_   IN Card_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Card_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.showlabel_ IS NOT NULL) THEN
      json_.put('showlabel', rec_.showlabel_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   IF (rec_.fieldranking_ IS NOT NULL) THEN
      IF (rec_.fieldranking_ IS NULL) THEN
         json_.put('fieldranking', JSON_ARRAY_T());
      ELSE
         json_.put('fieldranking', rec_.fieldranking_);
      END IF;
   END IF;
   IF (rec_.commands_ IS NOT NULL) THEN
      IF (rec_.commands_ IS NULL) THEN
         json_.put('commands', JSON_ARRAY_T());
      ELSE
         json_.put('commands', rec_.commands_);
      END IF;
   END IF;
   IF (rec_.commandgroups_ IS NOT NULL) THEN
      IF (rec_.commandgroups_ IS NULL) THEN
         json_.put('commandgroups', JSON_ARRAY_T());
      ELSE
         json_.put('commandgroups', rec_.commandgroups_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Showlabel (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.showlabel_ := value_;
END Set_Showlabel;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            PiechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            BarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            StackedchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            LinechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            RadarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            GanttchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            GanttchartItemElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            GanttchartRowElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            GanttchartItemStyleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            GanttchartRowIconElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            GanttDependencyElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            GanttchartTimemarkerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            GanttchartScheduleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            GanttchartLegendElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            BoxMatrixElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            CalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            CardElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            DiagramElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            FieldSetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            FileSelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            GroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            InlineGroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            ImageviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            ListElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            MarkdownTextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            PluginElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            ProcessviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            StackedCalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            SelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            SingletonElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            SheetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            SearchContextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            TimelineElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            YearViewElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            Arrange_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            TabsElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;

  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;
  
PROCEDURE Add_Fieldranking (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.fieldranking_ IS NULL) THEN
      rec_.fieldranking_ := JSON_ARRAY_T();
   END IF;
   rec_.fieldranking_.append(value_);
END Add_Fieldranking;
  
PROCEDURE Add_Commands (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.commands_ IS NULL) THEN
      rec_.commands_ := JSON_ARRAY_T();
   END IF;
   rec_.commands_.append(value_);
END Add_Commands;
  

PROCEDURE Add_Commandgroups (
   rec_   IN OUT NOCOPY Card_Rec,
   value_ IN            CommandGroup_Rec )
IS
BEGIN
   IF (rec_.commandgroups_ IS NULL) THEN
      rec_.commandgroups_ := JSON_ARRAY_T();
   END IF;
   rec_.commandgroups_.append(Build_Json___(value_));
END Add_Commandgroups;


FUNCTION Build (
   rec_   IN CardElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CardElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'card');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('card', rec_.card_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY CardElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY CardElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY CardElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Card (
   rec_   IN OUT NOCOPY CardElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.card_ := value_;
END Set_Card;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY CardElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;

FUNCTION Build (
   rec_   IN Diagram_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Diagram_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_OBJECT_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.displaylevels_ IS NULL) THEN
         json_.put('displaylevels', JSON_OBJECT_T());
      ELSE
         json_.put('displaylevels', rec_.displaylevels_);
      END IF;
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Content (
   rec_   IN OUT NOCOPY Diagram_Rec,
   value_ IN            DiagramContent_Rec )
IS
BEGIN
   rec_.content_ := Build_Json___(value_);
END Set_Content;

  

PROCEDURE Set_Displaylevels (
   rec_   IN OUT NOCOPY Diagram_Rec,
   value_ IN            DiagramDisplayLevels_Rec )
IS
BEGIN
   rec_.displaylevels_ := Build_Json___(value_);
END Set_Displaylevels;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Diagram_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Diagram_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;

FUNCTION Build (
   rec_   IN DiagramContent_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DiagramContent_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.nodes_ IS NULL) THEN
         json_.put('nodes', JSON_OBJECT_T());
      ELSE
         json_.put('nodes', rec_.nodes_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Nodes (
   rec_   IN OUT NOCOPY DiagramContent_Rec,
   value_ IN            DiagramNodes_Rec )
IS
BEGIN
   rec_.nodes_ := Build_Json___(value_);
END Set_Nodes;


FUNCTION Build (
   rec_   IN DiagramNodes_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DiagramNodes_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.node_ IS NULL) THEN
         json_.put('node', JSON_ARRAY_T());
      ELSE
         json_.put('node', rec_.node_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Add_Node (
   rec_   IN OUT NOCOPY DiagramNodes_Rec,
   value_ IN            DiagramNode_Rec )
IS
BEGIN
   IF (rec_.node_ IS NULL) THEN
      rec_.node_ := JSON_ARRAY_T();
   END IF;
   rec_.node_.append(Build_Json___(value_));
END Add_Node;


FUNCTION Build (
   rec_   IN DiagramDisplayLevels_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DiagramDisplayLevels_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('above', rec_.above_);
   END IF;
   IF (TRUE) THEN
      json_.put('below', rec_.below_);
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Above (
   rec_   IN OUT NOCOPY DiagramDisplayLevels_Rec,
   value_ IN            NUMBER )
IS
BEGIN
   rec_.above_ := value_;
END Set_Above;

  

PROCEDURE Set_Below (
   rec_   IN OUT NOCOPY DiagramDisplayLevels_Rec,
   value_ IN            NUMBER )
IS
BEGIN
   rec_.below_ := value_;
END Set_Below;


FUNCTION Build (
   rec_   IN DiagramNode_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DiagramNode_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.navigate_ IS NOT NULL) THEN
      json_.put('navigate', rec_.navigate_);
   END IF;
   IF (rec_.card_ IS NOT NULL) THEN
      json_.put('card', rec_.card_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.zoomlevels_ IS NULL) THEN
         json_.put('zoomlevels', JSON_OBJECT_T());
      ELSE
         json_.put('zoomlevels', rec_.zoomlevels_);
      END IF;
   END IF;
   IF (rec_.connections_ IS NOT NULL) THEN
      IF (rec_.connections_ IS NULL) THEN
         json_.put('connections', JSON_OBJECT_T());
      ELSE
         json_.put('connections', rec_.connections_);
      END IF;
   END IF;
   IF (rec_.links_ IS NOT NULL) THEN
      IF (rec_.links_ IS NULL) THEN
         json_.put('links', JSON_ARRAY_T());
      ELSE
         json_.put('links', rec_.links_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY DiagramNode_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY DiagramNode_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Navigate (
   rec_   IN OUT NOCOPY DiagramNode_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.navigate_ := value_;
END Set_Navigate;
  

PROCEDURE Set_Card (
   rec_   IN OUT NOCOPY DiagramNode_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.card_ := value_;
END Set_Card;

  

PROCEDURE Set_Zoomlevels (
   rec_   IN OUT NOCOPY DiagramNode_Rec,
   value_ IN            DiagramZoomLevels_Rec )
IS
BEGIN
   rec_.zoomlevels_ := Build_Json___(value_);
END Set_Zoomlevels;

  

PROCEDURE Set_Connections (
   rec_   IN OUT NOCOPY DiagramNode_Rec,
   value_ IN            DiagramConnections_Rec )
IS
BEGIN
   rec_.connections_ := Build_Json___(value_);
END Set_Connections;

  

PROCEDURE Add_Links (
   rec_   IN OUT NOCOPY DiagramNode_Rec,
   value_ IN            DiagramLinks_Rec )
IS
BEGIN
   IF (rec_.links_ IS NULL) THEN
      rec_.links_ := JSON_ARRAY_T();
   END IF;
   rec_.links_.append(Build_Json___(value_));
END Add_Links;


FUNCTION Build (
   rec_   IN DiagramZoomLevels_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DiagramZoomLevels_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.small_ IS NOT NULL) THEN
      IF (rec_.small_ IS NULL) THEN
         json_.put('small', JSON_OBJECT_T());
      ELSE
         json_.put('small', rec_.small_);
      END IF;
   END IF;
   IF (rec_.medium_ IS NOT NULL) THEN
      IF (rec_.medium_ IS NULL) THEN
         json_.put('medium', JSON_OBJECT_T());
      ELSE
         json_.put('medium', rec_.medium_);
      END IF;
   END IF;
   IF (rec_.large_ IS NOT NULL) THEN
      IF (rec_.large_ IS NULL) THEN
         json_.put('large', JSON_OBJECT_T());
      ELSE
         json_.put('large', rec_.large_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Small (
   rec_   IN OUT NOCOPY DiagramZoomLevels_Rec,
   value_ IN            DiagramZoomLevelRows_Rec )
IS
BEGIN
   rec_.small_ := Build_Json___(value_);
END Set_Small;

  

PROCEDURE Set_Medium (
   rec_   IN OUT NOCOPY DiagramZoomLevels_Rec,
   value_ IN            DiagramZoomLevelRows_Rec )
IS
BEGIN
   rec_.medium_ := Build_Json___(value_);
END Set_Medium;

  

PROCEDURE Set_Large (
   rec_   IN OUT NOCOPY DiagramZoomLevels_Rec,
   value_ IN            DiagramZoomLevelRows_Rec )
IS
BEGIN
   rec_.large_ := Build_Json___(value_);
END Set_Large;


FUNCTION Build (
   rec_   IN DiagramZoomLevelRows_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DiagramZoomLevelRows_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.rows_ IS NULL) THEN
         json_.put('rows', JSON_ARRAY_T());
      ELSE
         json_.put('rows', rec_.rows_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Add_Rows (
   rec_   IN OUT NOCOPY DiagramZoomLevelRows_Rec,
   value_ IN            Field_Rec )
IS
BEGIN
   IF (rec_.rows_ IS NULL) THEN
      rec_.rows_ := JSON_ARRAY_T();
   END IF;
   rec_.rows_.append(Build_Json___(value_));
END Add_Rows;


FUNCTION Build (
   rec_   IN DiagramConnections_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DiagramConnections_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.connection_ IS NULL) THEN
         json_.put('connection', JSON_ARRAY_T());
      ELSE
         json_.put('connection', rec_.connection_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Add_Connection (
   rec_   IN OUT NOCOPY DiagramConnections_Rec,
   value_ IN            DiagramConnection_Rec )
IS
BEGIN
   IF (rec_.connection_ IS NULL) THEN
      rec_.connection_ := JSON_ARRAY_T();
   END IF;
   rec_.connection_.append(Build_Json___(value_));
END Add_Connection;


FUNCTION Build (
   rec_   IN DiagramConnection_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DiagramConnection_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.reverse_ IS NOT NULL) THEN
      json_.put('reverse', rec_.reverse_);
   END IF;
   IF (TRUE) THEN
      json_.put('type', rec_.type_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Reverse (
   rec_   IN OUT NOCOPY DiagramConnection_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.reverse_ := value_;
END Set_Reverse;
  
PROCEDURE Set_Type (
   rec_   IN OUT NOCOPY DiagramConnection_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.type_ := value_;
END Set_Type;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY DiagramConnection_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN DiagramLinks_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DiagramLinks_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.link_ IS NULL) THEN
         json_.put('link', JSON_OBJECT_T());
      ELSE
         json_.put('link', rec_.link_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Link (
   rec_   IN OUT NOCOPY DiagramLinks_Rec,
   value_ IN            DiagramLink_Rec )
IS
BEGIN
   rec_.link_ := Build_Json___(value_);
END Set_Link;


FUNCTION Build (
   rec_   IN DiagramLink_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DiagramLink_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY DiagramLink_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY DiagramLink_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY DiagramLink_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;


FUNCTION Build (
   rec_   IN DiagramElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DiagramElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'diagram');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('diagram', rec_.diagram_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY DiagramElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY DiagramElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY DiagramElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Diagram (
   rec_   IN OUT NOCOPY DiagramElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.diagram_ := value_;
END Set_Diagram;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY DiagramElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY DiagramElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN Dialog_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Dialog_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.structure_ IS NOT NULL) THEN
      json_.put('structure', rec_.structure_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.size_ IS NOT NULL) THEN
      json_.put('size', rec_.size_);
   END IF;
   IF (rec_.init_ IS NOT NULL) THEN
      IF (rec_.init_ IS NULL) THEN
         json_.put('init', JSON_ARRAY_T());
      ELSE
         json_.put('init', rec_.init_);
      END IF;
   END IF;
   IF (rec_.content_ IS NOT NULL) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   IF (rec_.dialoginputdefinition_ IS NOT NULL) THEN
      IF (rec_.dialoginputdefinition_ IS NULL) THEN
         json_.put('dialoginputdefinition', JSON_ARRAY_T());
      ELSE
         json_.put('dialoginputdefinition', rec_.dialoginputdefinition_);
      END IF;
   END IF;
   IF (rec_.dialogoutputdefinition_ IS NOT NULL) THEN
      IF (rec_.dialogoutputdefinition_ IS NULL) THEN
         json_.put('dialogoutputdefinition', JSON_ARRAY_T());
      ELSE
         json_.put('dialogoutputdefinition', rec_.dialogoutputdefinition_);
      END IF;
   END IF;
   IF (rec_.commands_ IS NOT NULL) THEN
      IF (rec_.commands_ IS NULL) THEN
         json_.put('commands', JSON_ARRAY_T());
      ELSE
         json_.put('commands', rec_.commands_);
      END IF;
   END IF;
   IF (rec_.commandgroups_ IS NOT NULL) THEN
      IF (rec_.commandgroups_ IS NULL) THEN
         json_.put('commandgroups', JSON_ARRAY_T());
      ELSE
         json_.put('commandgroups', rec_.commandgroups_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Structure (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.structure_ := value_;
END Set_Structure;

  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Size (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.size_ := value_;
END Set_Size;
  

PROCEDURE Add_Init (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            Execute_Rec )
IS
BEGIN
   IF (rec_.init_ IS NULL) THEN
      rec_.init_ := JSON_ARRAY_T();
   END IF;
   rec_.init_.append(Build_Json___(value_));
END Add_Init;

  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            PiechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            BarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            StackedchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            LinechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            RadarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            GanttchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            GanttchartItemElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            GanttchartRowElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            GanttchartItemStyleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            GanttchartRowIconElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            GanttDependencyElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            GanttchartTimemarkerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            GanttchartScheduleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            GanttchartLegendElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            BoxMatrixElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            CalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            CardElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            DiagramElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            FieldSetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            FileSelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            GroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            InlineGroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            ImageviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            ListElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            MarkdownTextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            PluginElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            ProcessviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            StackedCalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            SelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            SingletonElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            SheetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            SearchContextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            TimelineElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            YearViewElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            Arrange_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            TabsElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;

  
PROCEDURE Add_Dialoginputdefinition (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.dialoginputdefinition_ IS NULL) THEN
      rec_.dialoginputdefinition_ := JSON_ARRAY_T();
   END IF;
   rec_.dialoginputdefinition_.append(value_);
END Add_Dialoginputdefinition;
  
PROCEDURE Add_Dialogoutputdefinition (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.dialogoutputdefinition_ IS NULL) THEN
      rec_.dialogoutputdefinition_ := JSON_ARRAY_T();
   END IF;
   rec_.dialogoutputdefinition_.append(value_);
END Add_Dialogoutputdefinition;
  
PROCEDURE Add_Commands (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.commands_ IS NULL) THEN
      rec_.commands_ := JSON_ARRAY_T();
   END IF;
   rec_.commands_.append(value_);
END Add_Commands;
  

PROCEDURE Add_Commandgroups (
   rec_   IN OUT NOCOPY Dialog_Rec,
   value_ IN            CommandGroup_Rec )
IS
BEGIN
   IF (rec_.commandgroups_ IS NULL) THEN
      rec_.commandgroups_ := JSON_ARRAY_T();
   END IF;
   rec_.commandgroups_.append(Build_Json___(value_));
END Add_Commandgroups;


FUNCTION Build (
   rec_   IN FieldElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN FieldElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'field');
   END IF;
   IF (TRUE) THEN
      NULL;
   END IF;
   IF (rec_.id_ IS NOT NULL) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.field_ IS NULL) THEN
         json_.put('field', JSON_OBJECT_T());
      ELSE
         json_.put('field', rec_.field_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY FieldElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY FieldElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY FieldElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Field (
   rec_   IN OUT NOCOPY FieldElement_Rec,
   value_ IN            Field_Rec )
IS
BEGIN
   rec_.field_ := Build_Json___(value_);
END Set_Field;


FUNCTION Build (
   rec_   IN Field_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Field_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (rec_.attribute_ IS NOT NULL) THEN
      json_.put('attribute', rec_.attribute_);
   END IF;
   IF (TRUE) THEN
      json_.put('control', rec_.control_);
   END IF;
   IF (rec_.valuefield_ IS NOT NULL) THEN
      json_.put('valuefield', rec_.valuefield_);
   END IF;
   IF (rec_.unitfield_ IS NOT NULL) THEN
      json_.put('unitfield', rec_.unitfield_);
   END IF;
   IF (rec_.uniteditable_ IS NOT NULL) THEN
      IF (rec_.uniteditable_ = 'TRUE') THEN
         json_.put('uniteditable', TRUE);
      ELSIF (rec_.uniteditable_ = 'FALSE') THEN
         json_.put('uniteditable', FALSE);
      ELSE
         json_.put('uniteditable', rec_.uniteditable_);
      END IF;
   END IF;
   IF (rec_.unitrequired_ IS NOT NULL) THEN
      IF (rec_.unitrequired_ = 'TRUE') THEN
         json_.put('unitrequired', TRUE);
      ELSIF (rec_.unitrequired_ = 'FALSE') THEN
         json_.put('unitrequired', FALSE);
      ELSE
         json_.put('unitrequired', rec_.unitrequired_);
      END IF;
   END IF;
   IF (rec_.unitvisible_ IS NOT NULL) THEN
      IF (rec_.unitvisible_ = 'TRUE') THEN
         json_.put('unitvisible', TRUE);
      ELSIF (rec_.unitvisible_ = 'FALSE') THEN
         json_.put('unitvisible', FALSE);
      ELSE
         json_.put('unitvisible', rec_.unitvisible_);
      END IF;
   END IF;
   IF (rec_.unitdatatype_ IS NOT NULL) THEN
      IF (rec_.unitdatatype_ = 'TRUE') THEN
         json_.put('unitdatatype', TRUE);
      ELSIF (rec_.unitdatatype_ = 'FALSE') THEN
         json_.put('unitdatatype', FALSE);
      ELSE
         json_.put('unitdatatype', rec_.unitdatatype_);
      END IF;
   END IF;
   IF (rec_.unitexportlabel_ IS NOT NULL) THEN
      IF (rec_.unitexportlabel_ = 'TRUE') THEN
         json_.put('unitexportlabel', TRUE);
      ELSIF (rec_.unitexportlabel_ = 'FALSE') THEN
         json_.put('unitexportlabel', FALSE);
      ELSE
         json_.put('unitexportlabel', rec_.unitexportlabel_);
      END IF;
   END IF;
   IF (rec_.structure_ IS NOT NULL) THEN
      json_.put('structure', rec_.structure_);
   END IF;
   IF (rec_.entity_ IS NOT NULL) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.filterlabel_ IS NOT NULL) THEN
      json_.put('filterlabel', rec_.filterlabel_);
   END IF;
   IF (rec_.showlabel_ IS NOT NULL) THEN
      json_.put('showlabel', rec_.showlabel_);
   END IF;
   IF (rec_.truelabel_ IS NOT NULL) THEN
      json_.put('truelabel', rec_.truelabel_);
   END IF;
   IF (rec_.falselabel_ IS NOT NULL) THEN
      json_.put('falselabel', rec_.falselabel_);
   END IF;
   IF (rec_.icon_ IS NOT NULL) THEN
      json_.put('icon', rec_.icon_);
   END IF;
   IF (rec_.style_ IS NOT NULL) THEN
      json_.put('style', rec_.style_);
   END IF;
   IF (rec_.image_ IS NOT NULL) THEN
      json_.put('image', rec_.image_);
   END IF;
   IF (rec_.mime_type_ IS NOT NULL) THEN
      json_.put('mimeType', rec_.mime_type_);
   END IF;
   IF (rec_.expression_ IS NOT NULL) THEN
      json_.put('expression', rec_.expression_);
   END IF;
   IF (TRUE) THEN
      json_.put('datatype', rec_.datatype_);
   END IF;
   IF (rec_.enumeration_ IS NOT NULL) THEN
      json_.put('enumeration', rec_.enumeration_);
   END IF;
   IF (rec_.reference_ IS NOT NULL) THEN
      json_.put('reference', rec_.reference_);
   END IF;
   IF (rec_.view_ IS NOT NULL) THEN
      IF (rec_.view_ IS NULL) THEN
         json_.put('view', JSON_OBJECT_T());
      ELSE
         json_.put('view', rec_.view_);
      END IF;
   END IF;
   IF (rec_.lov_ IS NOT NULL) THEN
      IF (rec_.lov_ IS NULL) THEN
         json_.put('lov', JSON_OBJECT_T());
      ELSE
         json_.put('lov', rec_.lov_);
      END IF;
   END IF;
   IF (rec_.lovswitch_ IS NOT NULL) THEN
      IF (rec_.lovswitch_ IS NULL) THEN
         json_.put('lovswitch', JSON_ARRAY_T());
      ELSE
         json_.put('lovswitch', rec_.lovswitch_);
      END IF;
   END IF;
   IF (rec_.update_ IS NOT NULL) THEN
      IF (rec_.update_ IS NULL) THEN
         json_.put('update', JSON_OBJECT_T());
      ELSE
         json_.put('update', rec_.update_);
      END IF;
   END IF;
   IF (rec_.detail_page_ IS NOT NULL) THEN
      json_.put('detailPage', rec_.detail_page_);
   END IF;
   IF (rec_.controlsize_ IS NOT NULL) THEN
      json_.put('controlsize', rec_.controlsize_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   IF (rec_.array_ IS NOT NULL) THEN
      json_.put('array', rec_.array_);
   END IF;
   IF (rec_.maxlength_ IS NOT NULL) THEN
      json_.put('maxlength', rec_.maxlength_);
   END IF;
   IF (rec_.format_ IS NOT NULL) THEN
      json_.put('format', rec_.format_);
   END IF;
   IF (rec_.multiline_ IS NOT NULL) THEN
      json_.put('multiline', rec_.multiline_);
   END IF;
   IF (rec_.editable_ IS NOT NULL) THEN
      IF (rec_.editable_ = 'TRUE') THEN
         json_.put('editable', TRUE);
      ELSIF (rec_.editable_ = 'FALSE') THEN
         json_.put('editable', FALSE);
      ELSE
         json_.put('editable', rec_.editable_);
      END IF;
   END IF;
   IF (rec_.required_ IS NOT NULL) THEN
      IF (rec_.required_ = 'TRUE') THEN
         json_.put('required', TRUE);
      ELSIF (rec_.required_ = 'FALSE') THEN
         json_.put('required', FALSE);
      ELSE
         json_.put('required', rec_.required_);
      END IF;
   END IF;
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   IF (rec_.searchable_ IS NOT NULL) THEN
      json_.put('searchable', rec_.searchable_);
   END IF;
   IF (rec_.column_visible_ IS NOT NULL) THEN
      IF (rec_.column_visible_ = 'TRUE') THEN
         json_.put('columnVisible', TRUE);
      ELSIF (rec_.column_visible_ = 'FALSE') THEN
         json_.put('columnVisible', FALSE);
      ELSE
         json_.put('columnVisible', rec_.column_visible_);
      END IF;
   END IF;
   IF (rec_.preserve_precision_ IS NOT NULL) THEN
      json_.put('preservePrecision', rec_.preserve_precision_);
   END IF;
   IF (rec_.column_exclude_ IS NOT NULL) THEN
      IF (rec_.column_exclude_ = 'TRUE') THEN
         json_.put('columnExclude', TRUE);
      ELSIF (rec_.column_exclude_ = 'FALSE') THEN
         json_.put('columnExclude', FALSE);
      ELSE
         json_.put('columnExclude', rec_.column_exclude_);
      END IF;
   END IF;
   IF (rec_.rating_ IS NOT NULL) THEN
      IF (rec_.rating_ IS NULL) THEN
         json_.put('rating', JSON_OBJECT_T());
      ELSE
         json_.put('rating', rec_.rating_);
      END IF;
   END IF;
   IF (rec_.colorpicker_ IS NOT NULL) THEN
      IF (rec_.colorpicker_ IS NULL) THEN
         json_.put('colorpicker', JSON_OBJECT_T());
      ELSE
         json_.put('colorpicker', rec_.colorpicker_);
      END IF;
   END IF;
   IF (rec_.qattributes_ IS NOT NULL) THEN
      IF (rec_.qattributes_ IS NULL) THEN
         json_.put('qattributes', JSON_OBJECT_T());
      ELSE
         json_.put('qattributes', rec_.qattributes_);
      END IF;
   END IF;
   IF (rec_.enabled_ IS NOT NULL) THEN
      IF (rec_.enabled_ = 'TRUE') THEN
         json_.put('enabled', TRUE);
      ELSIF (rec_.enabled_ = 'FALSE') THEN
         json_.put('enabled', FALSE);
      ELSE
         json_.put('enabled', rec_.enabled_);
      END IF;
   END IF;
   IF (rec_.daterange_ IS NOT NULL) THEN
      IF (rec_.daterange_ IS NULL) THEN
         json_.put('daterange', JSON_OBJECT_T());
      ELSE
         json_.put('daterange', rec_.daterange_);
      END IF;
   END IF;
   IF (rec_.ranking_ IS NOT NULL) THEN
      json_.put('ranking', rec_.ranking_);
   END IF;
   IF (rec_.contact_widget_ IS NOT NULL) THEN
      IF (rec_.contact_widget_ IS NULL) THEN
         json_.put('contactWidget', JSON_OBJECT_T());
      ELSE
         json_.put('contactWidget', rec_.contact_widget_);
      END IF;
   END IF;
   IF (rec_.validate_command_ IS NOT NULL) THEN
      IF (rec_.validate_command_ IS NULL) THEN
         json_.put('validateCommand', JSON_OBJECT_T());
      ELSE
         json_.put('validateCommand', rec_.validate_command_);
      END IF;
   END IF;
   IF (rec_.totalvalue_ IS NOT NULL) THEN
      IF (rec_.totalvalue_ IS NULL) THEN
         json_.put('totalvalue', JSON_OBJECT_T());
      ELSE
         json_.put('totalvalue', rec_.totalvalue_);
      END IF;
   END IF;
   IF (rec_.content_ IS NOT NULL) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  

PROCEDURE Set_Attribute (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.attribute_ := value_;
END Set_Attribute;

  
PROCEDURE Set_Control (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.control_ := value_;
END Set_Control;
  
PROCEDURE Set_Valuefield (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.valuefield_ := value_;
END Set_Valuefield;
  
PROCEDURE Set_Unitfield (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.unitfield_ := value_;
END Set_Unitfield;
  
PROCEDURE Set_Uniteditable (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.uniteditable_ := value_;
END Set_Uniteditable;


PROCEDURE Set_Uniteditable (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.uniteditable_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Uniteditable;
  
PROCEDURE Set_Unitrequired (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.unitrequired_ := value_;
END Set_Unitrequired;


PROCEDURE Set_Unitrequired (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.unitrequired_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Unitrequired;
  
PROCEDURE Set_Unitvisible (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.unitvisible_ := value_;
END Set_Unitvisible;


PROCEDURE Set_Unitvisible (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.unitvisible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Unitvisible;
  
PROCEDURE Set_Unitdatatype (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.unitdatatype_ := value_;
END Set_Unitdatatype;


PROCEDURE Set_Unitdatatype (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.unitdatatype_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Unitdatatype;
  
PROCEDURE Set_Unitexportlabel (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.unitexportlabel_ := value_;
END Set_Unitexportlabel;


PROCEDURE Set_Unitexportlabel (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.unitexportlabel_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Unitexportlabel;
  

PROCEDURE Set_Structure (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.structure_ := value_;
END Set_Structure;

  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Filterlabel (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.filterlabel_ := value_;
END Set_Filterlabel;
  
PROCEDURE Set_Showlabel (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.showlabel_ := value_;
END Set_Showlabel;
  
PROCEDURE Set_Truelabel (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.truelabel_ := value_;
END Set_Truelabel;
  
PROCEDURE Set_Falselabel (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.falselabel_ := value_;
END Set_Falselabel;
  
PROCEDURE Set_Icon (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.icon_ := value_;
END Set_Icon;
  
PROCEDURE Set_Style (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.style_ := value_;
END Set_Style;
  
PROCEDURE Set_Image (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.image_ := value_;
END Set_Image;
  
PROCEDURE Set_Mime_Type (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.mime_type_ := value_;
END Set_Mime_Type;
  
PROCEDURE Set_Expression (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.expression_ := value_;
END Set_Expression;
  
PROCEDURE Set_Datatype (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datatype_ := value_;
END Set_Datatype;
  
PROCEDURE Set_Enumeration (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.enumeration_ := value_;
END Set_Enumeration;
  
PROCEDURE Set_Reference (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.reference_ := value_;
END Set_Reference;
  

PROCEDURE Set_View (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            FieldView_Rec )
IS
BEGIN
   rec_.view_ := Build_Json___(value_);
END Set_View;

  

PROCEDURE Set_Lov (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            Lov_Rec )
IS
BEGIN
   rec_.lov_ := Build_Json___(value_);
END Set_Lov;

  

PROCEDURE Add_Lovswitch (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            LovSwitch_Rec )
IS
BEGIN
   IF (rec_.lovswitch_ IS NULL) THEN
      rec_.lovswitch_ := JSON_ARRAY_T();
   END IF;
   rec_.lovswitch_.append(Build_Json___(value_));
END Add_Lovswitch;

  

PROCEDURE Set_Update (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            AttributeUpdate_Rec )
IS
BEGIN
   rec_.update_ := Build_Json___(value_);
END Set_Update;

  
PROCEDURE Set_Detail_Page (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.detail_page_ := value_;
END Set_Detail_Page;
  
PROCEDURE Set_Controlsize (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.controlsize_ := value_;
END Set_Controlsize;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY Field_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;
  
PROCEDURE Set_Array (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.array_ := value_;
END Set_Array;
  

PROCEDURE Set_Maxlength (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            NUMBER )
IS
BEGIN
   rec_.maxlength_ := value_;
END Set_Maxlength;

  
PROCEDURE Set_Format (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.format_ := value_;
END Set_Format;
  
PROCEDURE Set_Multiline (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.multiline_ := value_;
END Set_Multiline;
  
PROCEDURE Set_Editable (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.editable_ := value_;
END Set_Editable;


PROCEDURE Set_Editable (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.editable_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Editable;
  
PROCEDURE Set_Required (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.required_ := value_;
END Set_Required;


PROCEDURE Set_Required (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.required_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Required;
  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;
  
PROCEDURE Set_Searchable (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.searchable_ := value_;
END Set_Searchable;
  
PROCEDURE Set_Column_Visible (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.column_visible_ := value_;
END Set_Column_Visible;


PROCEDURE Set_Column_Visible (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.column_visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Column_Visible;
  
PROCEDURE Set_Preserve_Precision (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.preserve_precision_ := value_;
END Set_Preserve_Precision;
  
PROCEDURE Set_Column_Exclude (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.column_exclude_ := value_;
END Set_Column_Exclude;


PROCEDURE Set_Column_Exclude (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.column_exclude_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Column_Exclude;
  

PROCEDURE Set_Rating (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            Rating_Rec )
IS
BEGIN
   rec_.rating_ := Build_Json___(value_);
END Set_Rating;

  

PROCEDURE Set_Colorpicker (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            ColorPicker_Rec )
IS
BEGIN
   rec_.colorpicker_ := Build_Json___(value_);
END Set_Colorpicker;

  

PROCEDURE Set_Qattributes (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            QAttributes_Rec )
IS
BEGIN
   rec_.qattributes_ := Build_Json___(value_);
END Set_Qattributes;

  
PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.enabled_ := value_;
END Set_Enabled;


PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.enabled_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Enabled;
  

PROCEDURE Set_Daterange (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            DateRange_Rec )
IS
BEGIN
   rec_.daterange_ := Build_Json___(value_);
END Set_Daterange;

  

PROCEDURE Set_Ranking (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            NUMBER )
IS
BEGIN
   rec_.ranking_ := value_;
END Set_Ranking;

  

PROCEDURE Set_Contact_Widget (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            ContactWidget_Rec )
IS
BEGIN
   rec_.contact_widget_ := Build_Json___(value_);
END Set_Contact_Widget;

  

PROCEDURE Set_Validate_Command (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.validate_command_ := Build_Json___(value_);
END Set_Validate_Command;

  

PROCEDURE Set_Totalvalue (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   rec_.totalvalue_ := Build_Json___(value_);
END Set_Totalvalue;

  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Field_Rec,
   value_ IN            FieldContent_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


FUNCTION Build (
   rec_   IN QAttributes_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN QAttributes_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('qflags', rec_.qflags_);
   END IF;
   IF (TRUE) THEN
      json_.put('qdatatype', rec_.qdatatype_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Qflags (
   rec_   IN OUT NOCOPY QAttributes_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.qflags_ := value_;
END Set_Qflags;
  
PROCEDURE Set_Qdatatype (
   rec_   IN OUT NOCOPY QAttributes_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.qdatatype_ := value_;
END Set_Qdatatype;

FUNCTION Build (
   rec_   IN Lov_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Lov_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('selector', rec_.selector_);
   END IF;
   IF (rec_.advancedview_ IS NOT NULL) THEN
      json_.put('advancedview', rec_.advancedview_);
   END IF;
   IF (TRUE) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.search_ IS NOT NULL) THEN
      IF (rec_.search_ IS NULL) THEN
         json_.put('search', JSON_ARRAY_T());
      ELSE
         json_.put('search', rec_.search_);
      END IF;
   END IF;
   IF (rec_.mapping_ IS NOT NULL) THEN
      IF (rec_.mapping_ IS NULL) THEN
         json_.put('mapping', JSON_OBJECT_T());
      ELSE
         json_.put('mapping', rec_.mapping_);
      END IF;
   END IF;
   IF (rec_.datasource_projection_ IS NOT NULL) THEN
      json_.put('datasourceProjection', rec_.datasource_projection_);
   END IF;
   IF (rec_.datasource_lookup_ IS NOT NULL) THEN
      json_.put('datasourceLookup', rec_.datasource_lookup_);
   END IF;
   IF (rec_.wildcards_ IS NOT NULL) THEN
      IF (rec_.wildcards_ IS NULL) THEN
         json_.put('wildcards', JSON_ARRAY_T());
      ELSE
         json_.put('wildcards', rec_.wildcards_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Selector (
   rec_   IN OUT NOCOPY Lov_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.selector_ := value_;
END Set_Selector;
  
PROCEDURE Set_Advancedview (
   rec_   IN OUT NOCOPY Lov_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.advancedview_ := value_;
END Set_Advancedview;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY Lov_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Add_Search (
   rec_   IN OUT NOCOPY Lov_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.search_ IS NULL) THEN
      rec_.search_ := JSON_ARRAY_T();
   END IF;
   rec_.search_.append(value_);
END Add_Search;
  

PROCEDURE Add_Mapping (
   rec_   IN OUT NOCOPY Lov_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.mapping_ IS NULL) THEN
      rec_.mapping_ := JSON_OBJECT_T();
   END IF;
   rec_.mapping_.put(name_, value_);
END Add_Mapping;

  
PROCEDURE Set_Datasource_Projection (
   rec_   IN OUT NOCOPY Lov_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_projection_ := value_;
END Set_Datasource_Projection;
  
PROCEDURE Set_Datasource_Lookup (
   rec_   IN OUT NOCOPY Lov_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_lookup_ := value_;
END Set_Datasource_Lookup;
  

PROCEDURE Add_Wildcards (
   rec_   IN OUT NOCOPY Lov_Rec,
   value_ IN            WildCards_Rec )
IS
BEGIN
   IF (rec_.wildcards_ IS NULL) THEN
      rec_.wildcards_ := JSON_ARRAY_T();
   END IF;
   rec_.wildcards_.append(Build_Json___(value_));
END Add_Wildcards;


FUNCTION Build (
   rec_   IN WildCards_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN WildCards_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('key', rec_.key_);
   END IF;
   IF (TRUE) THEN
      json_.put('description', rec_.description_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Key (
   rec_   IN OUT NOCOPY WildCards_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.key_ := value_;
END Set_Key;
  
PROCEDURE Set_Description (
   rec_   IN OUT NOCOPY WildCards_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.description_ := value_;
END Set_Description;

FUNCTION Build (
   rec_   IN LovSwitch_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN LovSwitch_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.case_ = 'TRUE') THEN
         json_.put('case', TRUE);
      ELSIF (rec_.case_ = 'FALSE') THEN
         json_.put('case', FALSE);
      ELSE
         json_.put('case', rec_.case_);
      END IF;
   END IF;
   IF (rec_.reference_ IS NOT NULL) THEN
      json_.put('reference', rec_.reference_);
   END IF;
   IF (rec_.lov_ IS NOT NULL) THEN
      IF (rec_.lov_ IS NULL) THEN
         json_.put('lov', JSON_OBJECT_T());
      ELSE
         json_.put('lov', rec_.lov_);
      END IF;
   END IF;
   IF (rec_.update_ IS NOT NULL) THEN
      IF (rec_.update_ IS NULL) THEN
         json_.put('update', JSON_OBJECT_T());
      ELSE
         json_.put('update', rec_.update_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Case (
   rec_   IN OUT NOCOPY LovSwitch_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.case_ := value_;
END Set_Case;


PROCEDURE Set_Case (
   rec_   IN OUT NOCOPY LovSwitch_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.case_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Case;
  
PROCEDURE Set_Reference (
   rec_   IN OUT NOCOPY LovSwitch_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.reference_ := value_;
END Set_Reference;
  

PROCEDURE Set_Lov (
   rec_   IN OUT NOCOPY LovSwitch_Rec,
   value_ IN            Lov_Rec )
IS
BEGIN
   rec_.lov_ := Build_Json___(value_);
END Set_Lov;

  

PROCEDURE Set_Update (
   rec_   IN OUT NOCOPY LovSwitch_Rec,
   value_ IN            AttributeUpdate_Rec )
IS
BEGIN
   rec_.update_ := Build_Json___(value_);
END Set_Update;


FUNCTION Build (
   rec_   IN DateRange_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DateRange_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.start_date_ IS NULL) THEN
         json_.put('startDate', JSON_OBJECT_T());
      ELSE
         json_.put('startDate', rec_.start_date_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.end_date_ IS NULL) THEN
         json_.put('endDate', JSON_OBJECT_T());
      ELSE
         json_.put('endDate', rec_.end_date_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Start_Date (
   rec_   IN OUT NOCOPY DateRange_Rec,
   value_ IN            DateRangeAttribute_Rec )
IS
BEGIN
   rec_.start_date_ := Build_Json___(value_);
END Set_Start_Date;

  

PROCEDURE Set_End_Date (
   rec_   IN OUT NOCOPY DateRange_Rec,
   value_ IN            DateRangeAttribute_Rec )
IS
BEGIN
   rec_.end_date_ := Build_Json___(value_);
END Set_End_Date;


FUNCTION Build (
   rec_   IN DateRangeAttribute_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DateRangeAttribute_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('attribute', rec_.attribute_);
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (TRUE) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Attribute (
   rec_   IN OUT NOCOPY DateRangeAttribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.attribute_ := value_;
END Set_Attribute;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY DateRangeAttribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY DateRangeAttribute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;

FUNCTION Build (
   rec_   IN AttributeUpdate_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN AttributeUpdate_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.copy_ IS NULL) THEN
         json_.put('copy', JSON_OBJECT_T());
      ELSE
         json_.put('copy', rec_.copy_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.fetch_ IS NULL) THEN
         json_.put('fetch', JSON_OBJECT_T());
      ELSE
         json_.put('fetch', rec_.fetch_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('item', rec_.item_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY AttributeUpdate_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Add_Copy (
   rec_   IN OUT NOCOPY AttributeUpdate_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.copy_ IS NULL) THEN
      rec_.copy_ := JSON_OBJECT_T();
   END IF;
   rec_.copy_.put(name_, value_);
END Add_Copy;

  

PROCEDURE Add_Fetch (
   rec_   IN OUT NOCOPY AttributeUpdate_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.fetch_ IS NULL) THEN
      rec_.fetch_ := JSON_OBJECT_T();
   END IF;
   rec_.fetch_.put(name_, value_);
END Add_Fetch;

  
PROCEDURE Set_Item (
   rec_   IN OUT NOCOPY AttributeUpdate_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.item_ := value_;
END Set_Item;

FUNCTION Build (
   rec_   IN FieldView_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN FieldView_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.description_ IS NOT NULL) THEN
      json_.put('description', rec_.description_);
   END IF;
   IF (rec_.card_ IS NOT NULL) THEN
      json_.put('card', rec_.card_);
   END IF;
   IF (rec_.template_ IS NOT NULL) THEN
      json_.put('template', rec_.template_);
   END IF;
   IF (rec_.hide_key_ IS NOT NULL) THEN
      IF (rec_.hide_key_ = 'TRUE') THEN
         json_.put('hideKey', TRUE);
      ELSIF (rec_.hide_key_ = 'FALSE') THEN
         json_.put('hideKey', FALSE);
      ELSE
         json_.put('hideKey', rec_.hide_key_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Description (
   rec_   IN OUT NOCOPY FieldView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.description_ := value_;
END Set_Description;
  

PROCEDURE Set_Card (
   rec_   IN OUT NOCOPY FieldView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.card_ := value_;
END Set_Card;

  
PROCEDURE Set_Template (
   rec_   IN OUT NOCOPY FieldView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.template_ := value_;
END Set_Template;
  
PROCEDURE Set_Hide_Key (
   rec_   IN OUT NOCOPY FieldView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.hide_key_ := value_;
END Set_Hide_Key;


PROCEDURE Set_Hide_Key (
   rec_   IN OUT NOCOPY FieldView_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.hide_key_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Hide_Key;

FUNCTION Build (
   rec_   IN ContactWidget_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ContactWidget_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.enabled_ = 'TRUE') THEN
         json_.put('enabled', TRUE);
      ELSIF (rec_.enabled_ = 'FALSE') THEN
         json_.put('enabled', FALSE);
      ELSE
         json_.put('enabled', rec_.enabled_);
      END IF;
   END IF;
   IF (rec_.source_ IS NOT NULL) THEN
      IF (rec_.source_ IS NULL) THEN
         json_.put('source', JSON_OBJECT_T());
      ELSE
         json_.put('source', rec_.source_);
      END IF;
   END IF;
   IF (rec_.key_ IS NOT NULL) THEN
      json_.put('key', rec_.key_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY ContactWidget_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.enabled_ := value_;
END Set_Enabled;


PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY ContactWidget_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.enabled_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Enabled;
  

PROCEDURE Set_Source (
   rec_   IN OUT NOCOPY ContactWidget_Rec,
   value_ IN            ContactWidgetSource_Rec )
IS
BEGIN
   rec_.source_ := Build_Json___(value_);
END Set_Source;

  
PROCEDURE Set_Key (
   rec_   IN OUT NOCOPY ContactWidget_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.key_ := value_;
END Set_Key;

FUNCTION Build (
   rec_   IN ContactWidgetSource_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ContactWidgetSource_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.person_ IS NOT NULL) THEN
      IF (rec_.person_ = 'TRUE') THEN
         json_.put('Person', TRUE);
      ELSIF (rec_.person_ = 'FALSE') THEN
         json_.put('Person', FALSE);
      ELSE
         json_.put('Person', rec_.person_);
      END IF;
   END IF;
   IF (rec_.customer_ IS NOT NULL) THEN
      IF (rec_.customer_ = 'TRUE') THEN
         json_.put('Customer', TRUE);
      ELSIF (rec_.customer_ = 'FALSE') THEN
         json_.put('Customer', FALSE);
      ELSE
         json_.put('Customer', rec_.customer_);
      END IF;
   END IF;
   IF (rec_.supplier_ IS NOT NULL) THEN
      IF (rec_.supplier_ = 'TRUE') THEN
         json_.put('Supplier', TRUE);
      ELSIF (rec_.supplier_ = 'FALSE') THEN
         json_.put('Supplier', FALSE);
      ELSE
         json_.put('Supplier', rec_.supplier_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Person (
   rec_   IN OUT NOCOPY ContactWidgetSource_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.person_ := value_;
END Set_Person;


PROCEDURE Set_Person (
   rec_   IN OUT NOCOPY ContactWidgetSource_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.person_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Person;
  
PROCEDURE Set_Customer (
   rec_   IN OUT NOCOPY ContactWidgetSource_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.customer_ := value_;
END Set_Customer;


PROCEDURE Set_Customer (
   rec_   IN OUT NOCOPY ContactWidgetSource_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.customer_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Customer;
  
PROCEDURE Set_Supplier (
   rec_   IN OUT NOCOPY ContactWidgetSource_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.supplier_ := value_;
END Set_Supplier;


PROCEDURE Set_Supplier (
   rec_   IN OUT NOCOPY ContactWidgetSource_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.supplier_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Supplier;

FUNCTION Build (
   rec_   IN DatasourceReference_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DatasourceReference_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY DatasourceReference_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;

FUNCTION Build (
   rec_   IN Rating_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Rating_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.showlabel_ IS NOT NULL) THEN
      json_.put('showlabel', rec_.showlabel_);
   END IF;
   IF (rec_.maxrating_ IS NOT NULL) THEN
      json_.put('maxrating', rec_.maxrating_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Showlabel (
   rec_   IN OUT NOCOPY Rating_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.showlabel_ := value_;
END Set_Showlabel;
  

PROCEDURE Set_Maxrating (
   rec_   IN OUT NOCOPY Rating_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.maxrating_ := value_;
END Set_Maxrating;


FUNCTION Build (
   rec_   IN FieldContent_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN FieldContent_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.column_ IS NULL) THEN
         json_.put('column', JSON_OBJECT_T());
      ELSE
         json_.put('column', rec_.column_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Column (
   rec_   IN OUT NOCOPY FieldContent_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   rec_.column_ := Build_Json___(value_);
END Set_Column;


FUNCTION Build (
   rec_   IN ProgressElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ProgressElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('attribute', rec_.attribute_);
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.value_label_ IS NOT NULL) THEN
      json_.put('valueLabel', rec_.value_label_);
   END IF;
   IF (rec_.value_label_attribute_ IS NOT NULL) THEN
      json_.put('valueLabelAttribute', rec_.value_label_attribute_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Attribute (
   rec_   IN OUT NOCOPY ProgressElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.attribute_ := value_;
END Set_Attribute;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY ProgressElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY ProgressElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Value_Label (
   rec_   IN OUT NOCOPY ProgressElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.value_label_ := value_;
END Set_Value_Label;
  
PROCEDURE Set_Value_Label_Attribute (
   rec_   IN OUT NOCOPY ProgressElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.value_label_attribute_ := value_;
END Set_Value_Label_Attribute;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY ProgressElement_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;

FUNCTION Build (
   rec_   IN ColorPicker_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ColorPicker_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.defaultemphasis_ IS NOT NULL) THEN
      json_.put('defaultemphasis', rec_.defaultemphasis_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Defaultemphasis (
   rec_   IN OUT NOCOPY ColorPicker_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.defaultemphasis_ := value_;
END Set_Defaultemphasis;

FUNCTION Build (
   rec_   IN FieldSetElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN FieldSetElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'fieldset');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('fieldset', rec_.fieldset_);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY FieldSetElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY FieldSetElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Fieldset (
   rec_   IN OUT NOCOPY FieldSetElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.fieldset_ := value_;
END Set_Fieldset;

  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY FieldSetElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;

FUNCTION Build (
   rec_   IN FieldSet_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN FieldSet_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (rec_.entity_ IS NOT NULL) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.content_ IS NOT NULL) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            PiechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            BarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            StackedchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            LinechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            RadarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            GanttchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            GanttchartItemElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            GanttchartRowElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            GanttchartItemStyleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            GanttchartRowIconElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            GanttDependencyElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            GanttchartTimemarkerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            GanttchartScheduleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            GanttchartLegendElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            BoxMatrixElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            CalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            CardElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            DiagramElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            FieldSetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            FileSelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            GroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            InlineGroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            ImageviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            ListElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            MarkdownTextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            PluginElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            ProcessviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            StackedCalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            SelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            SingletonElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            SheetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            SearchContextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            TimelineElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            YearViewElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            Arrange_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY FieldSet_Rec,
   value_ IN            TabsElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


FUNCTION Build (
   rec_   IN FileSelector_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN FileSelector_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.enabled_ IS NOT NULL) THEN
      IF (rec_.enabled_ = 'TRUE') THEN
         json_.put('enabled', TRUE);
      ELSIF (rec_.enabled_ = 'FALSE') THEN
         json_.put('enabled', FALSE);
      ELSE
         json_.put('enabled', rec_.enabled_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('multiple', rec_.multiple_);
   END IF;
   IF (rec_.init_command_ IS NOT NULL) THEN
      IF (rec_.init_command_ IS NULL) THEN
         json_.put('initCommand', JSON_OBJECT_T());
      ELSE
         json_.put('initCommand', rec_.init_command_);
      END IF;
   END IF;
   IF (rec_.on_file_select_command_ IS NOT NULL) THEN
      IF (rec_.on_file_select_command_ IS NULL) THEN
         json_.put('onFileSelectCommand', JSON_OBJECT_T());
      ELSE
         json_.put('onFileSelectCommand', rec_.on_file_select_command_);
      END IF;
   END IF;
   IF (rec_.on_file_delete_command_ IS NOT NULL) THEN
      IF (rec_.on_file_delete_command_ IS NULL) THEN
         json_.put('onFileDeleteCommand', JSON_OBJECT_T());
      ELSE
         json_.put('onFileDeleteCommand', rec_.on_file_delete_command_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY FileSelector_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY FileSelector_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY FileSelector_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY FileSelector_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.enabled_ := value_;
END Set_Enabled;


PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY FileSelector_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.enabled_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Enabled;
  
PROCEDURE Set_Multiple (
   rec_   IN OUT NOCOPY FileSelector_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.multiple_ := value_;
END Set_Multiple;
  

PROCEDURE Set_Init_Command (
   rec_   IN OUT NOCOPY FileSelector_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.init_command_ := Build_Json___(value_);
END Set_Init_Command;

  

PROCEDURE Set_On_File_Select_Command (
   rec_   IN OUT NOCOPY FileSelector_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.on_file_select_command_ := Build_Json___(value_);
END Set_On_File_Select_Command;

  

PROCEDURE Set_On_File_Delete_Command (
   rec_   IN OUT NOCOPY FileSelector_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.on_file_delete_command_ := Build_Json___(value_);
END Set_On_File_Delete_Command;


FUNCTION Build (
   rec_   IN FileSelectorElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN FileSelectorElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'fileselector');
   END IF;
   IF (TRUE) THEN
      NULL;
   END IF;
   IF (TRUE) THEN
      IF (rec_.fileselector_ IS NULL) THEN
         json_.put('fileselector', JSON_OBJECT_T());
      ELSE
         json_.put('fileselector', rec_.fileselector_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY FileSelectorElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY FileSelectorElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Fileselector (
   rec_   IN OUT NOCOPY FileSelectorElement_Rec,
   value_ IN            FileSelector_Rec )
IS
BEGIN
   rec_.fileselector_ := Build_Json___(value_);
END Set_Fileselector;


FUNCTION Build (
   rec_   IN Group_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Group_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.showlabel_ IS NOT NULL) THEN
      json_.put('showlabel', rec_.showlabel_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.structure_ IS NOT NULL) THEN
      json_.put('structure', rec_.structure_);
   END IF;
   IF (rec_.entity_ IS NOT NULL) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      IF (rec_.collapsed_ = 'TRUE') THEN
         json_.put('collapsed', TRUE);
      ELSIF (rec_.collapsed_ = 'FALSE') THEN
         json_.put('collapsed', FALSE);
      ELSE
         json_.put('collapsed', rec_.collapsed_);
      END IF;
   END IF;
   IF (rec_.content_ IS NOT NULL) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   IF (rec_.commands_ IS NOT NULL) THEN
      IF (rec_.commands_ IS NULL) THEN
         json_.put('commands', JSON_ARRAY_T());
      ELSE
         json_.put('commands', rec_.commands_);
      END IF;
   END IF;
   IF (rec_.commandgroups_ IS NOT NULL) THEN
      IF (rec_.commandgroups_ IS NULL) THEN
         json_.put('commandgroups', JSON_ARRAY_T());
      ELSE
         json_.put('commandgroups', rec_.commandgroups_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Showlabel (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.showlabel_ := value_;
END Set_Showlabel;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Structure (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.structure_ := value_;
END Set_Structure;

  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;
  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;


PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Collapsed;
  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            PiechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            BarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            StackedchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            LinechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            RadarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            GanttchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            GanttchartItemElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            GanttchartRowElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            GanttchartItemStyleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            GanttchartRowIconElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            GanttDependencyElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            GanttchartTimemarkerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            GanttchartScheduleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            GanttchartLegendElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            BoxMatrixElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            CalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            CardElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            DiagramElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            FieldSetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            FileSelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            GroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            InlineGroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            ImageviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            ListElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            MarkdownTextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            PluginElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            ProcessviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            StackedCalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            SelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            SingletonElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            SheetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            SearchContextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            TimelineElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            YearViewElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            Arrange_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            TabsElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;

  
PROCEDURE Add_Commands (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.commands_ IS NULL) THEN
      rec_.commands_ := JSON_ARRAY_T();
   END IF;
   rec_.commands_.append(value_);
END Add_Commands;
  

PROCEDURE Add_Commandgroups (
   rec_   IN OUT NOCOPY Group_Rec,
   value_ IN            CommandGroup_Rec )
IS
BEGIN
   IF (rec_.commandgroups_ IS NULL) THEN
      rec_.commandgroups_ := JSON_ARRAY_T();
   END IF;
   rec_.commandgroups_.append(Build_Json___(value_));
END Add_Commandgroups;


FUNCTION Build (
   rec_   IN GroupElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN GroupElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'group');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('group', rec_.group_);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (rec_.override_ IS NOT NULL) THEN
      IF (rec_.override_ IS NULL) THEN
         json_.put('override', JSON_OBJECT_T());
      ELSE
         json_.put('override', rec_.override_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY GroupElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY GroupElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Group (
   rec_   IN OUT NOCOPY GroupElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.group_ := value_;
END Set_Group;

  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY GroupElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY GroupElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY GroupElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  

PROCEDURE Set_Override (
   rec_   IN OUT NOCOPY GroupElement_Rec,
   value_ IN            Override_Rec )
IS
BEGIN
   rec_.override_ := Build_Json___(value_);
END Set_Override;


FUNCTION Build (
   rec_   IN InlineGroupElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN InlineGroupElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'group');
   END IF;
   IF (TRUE) THEN
      NULL;
   END IF;
   IF (TRUE) THEN
      IF (rec_.group_ IS NULL) THEN
         json_.put('group', JSON_OBJECT_T());
      ELSE
         json_.put('group', rec_.group_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY InlineGroupElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY InlineGroupElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Group (
   rec_   IN OUT NOCOPY InlineGroupElement_Rec,
   value_ IN            Group_Rec )
IS
BEGIN
   rec_.group_ := Build_Json___(value_);
END Set_Group;


FUNCTION Build (
   rec_   IN Imageviewer_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Imageviewer_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      IF (rec_.collapsed_ = 'TRUE') THEN
         json_.put('collapsed', TRUE);
      ELSIF (rec_.collapsed_ = 'FALSE') THEN
         json_.put('collapsed', FALSE);
      ELSE
         json_.put('collapsed', rec_.collapsed_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('scalingMode', rec_.scaling_mode_);
   END IF;
   IF (rec_.height_ IS NOT NULL) THEN
      json_.put('height', rec_.height_);
   END IF;
   IF (rec_.default_image_ IS NOT NULL) THEN
      json_.put('defaultImage', rec_.default_image_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.documents_ IS NOT NULL) THEN
      IF (rec_.documents_ IS NULL) THEN
         json_.put('documents', JSON_OBJECT_T());
      ELSE
         json_.put('documents', rec_.documents_);
      END IF;
   END IF;
   IF (rec_.media_ IS NOT NULL) THEN
      IF (rec_.media_ IS NULL) THEN
         json_.put('media', JSON_OBJECT_T());
      ELSE
         json_.put('media', rec_.media_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.images_ IS NULL) THEN
         json_.put('images', JSON_ARRAY_T());
      ELSE
         json_.put('images', rec_.images_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Imageviewer_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY Imageviewer_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Imageviewer_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Imageviewer_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Imageviewer_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;


PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Imageviewer_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Collapsed;
  
PROCEDURE Set_Scaling_Mode (
   rec_   IN OUT NOCOPY Imageviewer_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.scaling_mode_ := value_;
END Set_Scaling_Mode;
  
PROCEDURE Set_Height (
   rec_   IN OUT NOCOPY Imageviewer_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.height_ := value_;
END Set_Height;
  
PROCEDURE Set_Default_Image (
   rec_   IN OUT NOCOPY Imageviewer_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.default_image_ := value_;
END Set_Default_Image;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Imageviewer_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  

PROCEDURE Set_Documents (
   rec_   IN OUT NOCOPY Imageviewer_Rec,
   value_ IN            DocumentsSetting_Rec )
IS
BEGIN
   rec_.documents_ := Build_Json___(value_);
END Set_Documents;

  

PROCEDURE Set_Media (
   rec_   IN OUT NOCOPY Imageviewer_Rec,
   value_ IN            Media_Rec )
IS
BEGIN
   rec_.media_ := Build_Json___(value_);
END Set_Media;

  

PROCEDURE Add_Images (
   rec_   IN OUT NOCOPY Imageviewer_Rec,
   value_ IN            ImagePath_Rec )
IS
BEGIN
   IF (rec_.images_ IS NULL) THEN
      rec_.images_ := JSON_ARRAY_T();
   END IF;
   rec_.images_.append(Build_Json___(value_));
END Add_Images;


FUNCTION Build (
   rec_   IN ImagePath_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ImagePath_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('url', rec_.url_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY ImagePath_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY ImagePath_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Url (
   rec_   IN OUT NOCOPY ImagePath_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.url_ := value_;
END Set_Url;

FUNCTION Build (
   rec_   IN DocumentsSetting_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DocumentsSetting_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.enabled_ = 'TRUE') THEN
         json_.put('enabled', TRUE);
      ELSIF (rec_.enabled_ = 'FALSE') THEN
         json_.put('enabled', FALSE);
      ELSE
         json_.put('enabled', rec_.enabled_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY DocumentsSetting_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.enabled_ := value_;
END Set_Enabled;


PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY DocumentsSetting_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.enabled_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Enabled;

FUNCTION Build (
   rec_   IN ImageviewerElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ImageviewerElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'imageviewer');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('imageviewer', rec_.imageviewer_);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (rec_.override_ IS NOT NULL) THEN
      IF (rec_.override_ IS NULL) THEN
         json_.put('override', JSON_OBJECT_T());
      ELSE
         json_.put('override', rec_.override_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY ImageviewerElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY ImageviewerElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Imageviewer (
   rec_   IN OUT NOCOPY ImageviewerElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.imageviewer_ := value_;
END Set_Imageviewer;

  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY ImageviewerElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY ImageviewerElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY ImageviewerElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  

PROCEDURE Set_Override (
   rec_   IN OUT NOCOPY ImageviewerElement_Rec,
   value_ IN            ImageviewerElementOverride_Rec )
IS
BEGIN
   rec_.override_ := Build_Json___(value_);
END Set_Override;


FUNCTION Build (
   rec_   IN ImageviewerElementOverride_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ImageviewerElementOverride_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY ImageviewerElementOverride_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY ImageviewerElementOverride_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;

FUNCTION Build (
   rec_   IN ListElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ListElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'list');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('list', rec_.list_);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (rec_.detail_page_ IS NOT NULL) THEN
      json_.put('detailPage', rec_.detail_page_);
   END IF;
   IF (rec_.override_ IS NOT NULL) THEN
      IF (rec_.override_ IS NULL) THEN
         json_.put('override', JSON_OBJECT_T());
      ELSE
         json_.put('override', rec_.override_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY ListElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY ListElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_List (
   rec_   IN OUT NOCOPY ListElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.list_ := value_;
END Set_List;

  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY ListElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY ListElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY ListElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  
PROCEDURE Set_Detail_Page (
   rec_   IN OUT NOCOPY ListElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.detail_page_ := value_;
END Set_Detail_Page;
  

PROCEDURE Set_Override (
   rec_   IN OUT NOCOPY ListElement_Rec,
   value_ IN            Override_Rec )
IS
BEGIN
   rec_.override_ := Build_Json___(value_);
END Set_Override;


FUNCTION Build (
   rec_   IN List_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN List_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   IF (rec_.preselect_ IS NOT NULL) THEN
      IF (rec_.preselect_ = 'TRUE') THEN
         json_.put('preselect', TRUE);
      ELSIF (rec_.preselect_ = 'FALSE') THEN
         json_.put('preselect', FALSE);
      ELSE
         json_.put('preselect', rec_.preselect_);
      END IF;
   END IF;
   IF (rec_.multiselect_ IS NOT NULL) THEN
      IF (rec_.multiselect_ = 'TRUE') THEN
         json_.put('multiselect', TRUE);
      ELSIF (rec_.multiselect_ = 'FALSE') THEN
         json_.put('multiselect', FALSE);
      ELSE
         json_.put('multiselect', rec_.multiselect_);
      END IF;
   END IF;
   IF (rec_.editmode_ IS NOT NULL) THEN
      json_.put('editmode', rec_.editmode_);
   END IF;
   IF (rec_.initialview_ IS NOT NULL) THEN
      json_.put('initialview', rec_.initialview_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   IF (rec_.singlerecordedit_ IS NOT NULL) THEN
      IF (rec_.singlerecordedit_ = 'TRUE') THEN
         json_.put('singlerecordedit', TRUE);
      ELSIF (rec_.singlerecordedit_ = 'FALSE') THEN
         json_.put('singlerecordedit', FALSE);
      ELSE
         json_.put('singlerecordedit', rec_.singlerecordedit_);
      END IF;
   END IF;
   IF (rec_.disable_ IS NOT NULL) THEN
      json_.put('disable', rec_.disable_);
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      IF (rec_.collapsed_ = 'TRUE') THEN
         json_.put('collapsed', TRUE);
      ELSIF (rec_.collapsed_ = 'FALSE') THEN
         json_.put('collapsed', FALSE);
      ELSE
         json_.put('collapsed', rec_.collapsed_);
      END IF;
   END IF;
   IF (rec_.favoritecolumn_ IS NOT NULL) THEN
      IF (rec_.favoritecolumn_ = 'TRUE') THEN
         json_.put('favoritecolumn', TRUE);
      ELSIF (rec_.favoritecolumn_ = 'FALSE') THEN
         json_.put('favoritecolumn', FALSE);
      ELSE
         json_.put('favoritecolumn', rec_.favoritecolumn_);
      END IF;
   END IF;
   IF (rec_.crudactions_ IS NOT NULL) THEN
      IF (rec_.crudactions_ IS NULL) THEN
         json_.put('crudactions', JSON_OBJECT_T());
      ELSE
         json_.put('crudactions', rec_.crudactions_);
      END IF;
   END IF;
   IF (rec_.card_ IS NOT NULL) THEN
      json_.put('card', rec_.card_);
   END IF;
   IF (rec_.boxmatrix_ IS NOT NULL) THEN
      json_.put('boxmatrix', rec_.boxmatrix_);
   END IF;
   IF (rec_.searchcontext_ IS NOT NULL) THEN
      IF (rec_.searchcontext_ IS NULL) THEN
         json_.put('searchcontext', JSON_ARRAY_T());
      ELSE
         json_.put('searchcontext', rec_.searchcontext_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   IF (rec_.fieldranking_ IS NOT NULL) THEN
      IF (rec_.fieldranking_ IS NULL) THEN
         json_.put('fieldranking', JSON_ARRAY_T());
      ELSE
         json_.put('fieldranking', rec_.fieldranking_);
      END IF;
   END IF;
   IF (rec_.verticalmode_ IS NOT NULL) THEN
      IF (rec_.verticalmode_ IS NULL) THEN
         json_.put('verticalmode', JSON_ARRAY_T());
      ELSE
         json_.put('verticalmode', rec_.verticalmode_);
      END IF;
   END IF;
   IF (rec_.summary_ IS NOT NULL) THEN
      IF (rec_.summary_ IS NULL) THEN
         json_.put('summary', JSON_ARRAY_T());
      ELSE
         json_.put('summary', rec_.summary_);
      END IF;
   END IF;
   IF (rec_.commands_ IS NOT NULL) THEN
      IF (rec_.commands_ IS NULL) THEN
         json_.put('commands', JSON_ARRAY_T());
      ELSE
         json_.put('commands', rec_.commands_);
      END IF;
   END IF;
   IF (rec_.commandgroups_ IS NOT NULL) THEN
      IF (rec_.commandgroups_ IS NULL) THEN
         json_.put('commandgroups', JSON_ARRAY_T());
      ELSE
         json_.put('commandgroups', rec_.commandgroups_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;
  
PROCEDURE Set_Preselect (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.preselect_ := value_;
END Set_Preselect;


PROCEDURE Set_Preselect (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.preselect_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Preselect;
  
PROCEDURE Set_Multiselect (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.multiselect_ := value_;
END Set_Multiselect;


PROCEDURE Set_Multiselect (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.multiselect_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Multiselect;
  
PROCEDURE Set_Editmode (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.editmode_ := value_;
END Set_Editmode;
  
PROCEDURE Set_Initialview (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.initialview_ := value_;
END Set_Initialview;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY List_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;
  
PROCEDURE Set_Singlerecordedit (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.singlerecordedit_ := value_;
END Set_Singlerecordedit;


PROCEDURE Set_Singlerecordedit (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.singlerecordedit_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Singlerecordedit;
  
PROCEDURE Set_Disable (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.disable_ := value_;
END Set_Disable;
  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;


PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Collapsed;
  
PROCEDURE Set_Favoritecolumn (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.favoritecolumn_ := value_;
END Set_Favoritecolumn;


PROCEDURE Set_Favoritecolumn (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.favoritecolumn_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Favoritecolumn;
  

PROCEDURE Set_Crudactions (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            CrudActions_Rec )
IS
BEGIN
   rec_.crudactions_ := Build_Json___(value_);
END Set_Crudactions;

  

PROCEDURE Set_Card (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.card_ := value_;
END Set_Card;

  
PROCEDURE Set_Boxmatrix (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.boxmatrix_ := value_;
END Set_Boxmatrix;
  

PROCEDURE Add_Searchcontext (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            SearchContext_Rec )
IS
BEGIN
   IF (rec_.searchcontext_ IS NULL) THEN
      rec_.searchcontext_ := JSON_ARRAY_T();
   END IF;
   rec_.searchcontext_.append(Build_Json___(value_));
END Add_Searchcontext;

  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            PiechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            BarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            StackedchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            LinechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            RadarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            GanttchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            GanttchartItemElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            GanttchartRowElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            GanttchartItemStyleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            GanttchartRowIconElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            GanttDependencyElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            GanttchartTimemarkerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            GanttchartScheduleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            GanttchartLegendElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            BoxMatrixElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            CalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            CardElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            DiagramElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            FieldSetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            FileSelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            GroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            InlineGroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            ImageviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            ListElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            MarkdownTextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            PluginElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            ProcessviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            StackedCalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            SelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            SingletonElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            SheetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            SearchContextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            TimelineElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            YearViewElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            Arrange_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            TabsElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;

  
PROCEDURE Add_Fieldranking (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.fieldranking_ IS NULL) THEN
      rec_.fieldranking_ := JSON_ARRAY_T();
   END IF;
   rec_.fieldranking_.append(value_);
END Add_Fieldranking;
  
PROCEDURE Add_Verticalmode (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.verticalmode_ IS NULL) THEN
      rec_.verticalmode_ := JSON_ARRAY_T();
   END IF;
   rec_.verticalmode_.append(value_);
END Add_Verticalmode;
  
PROCEDURE Add_Summary (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.summary_ IS NULL) THEN
      rec_.summary_ := JSON_ARRAY_T();
   END IF;
   rec_.summary_.append(value_);
END Add_Summary;
  
PROCEDURE Add_Commands (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.commands_ IS NULL) THEN
      rec_.commands_ := JSON_ARRAY_T();
   END IF;
   rec_.commands_.append(value_);
END Add_Commands;
  

PROCEDURE Add_Commandgroups (
   rec_   IN OUT NOCOPY List_Rec,
   value_ IN            CommandGroup_Rec )
IS
BEGIN
   IF (rec_.commandgroups_ IS NULL) THEN
      rec_.commandgroups_ := JSON_ARRAY_T();
   END IF;
   rec_.commandgroups_.append(Build_Json___(value_));
END Add_Commandgroups;


FUNCTION Build (
   rec_   IN MarkdownText_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN MarkdownText_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('text', rec_.text_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY MarkdownText_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  
PROCEDURE Set_Text (
   rec_   IN OUT NOCOPY MarkdownText_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.text_ := value_;
END Set_Text;
  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY MarkdownText_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY MarkdownText_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY MarkdownText_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY MarkdownText_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;


FUNCTION Build (
   rec_   IN MarkdownTextElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN MarkdownTextElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'markdowntext');
   END IF;
   IF (TRUE) THEN
      NULL;
   END IF;
   IF (TRUE) THEN
      IF (rec_.markdowntext_ IS NULL) THEN
         json_.put('markdowntext', JSON_OBJECT_T());
      ELSE
         json_.put('markdowntext', rec_.markdowntext_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY MarkdownTextElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY MarkdownTextElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Markdowntext (
   rec_   IN OUT NOCOPY MarkdownTextElement_Rec,
   value_ IN            MarkdownText_Rec )
IS
BEGIN
   rec_.markdowntext_ := Build_Json___(value_);
END Set_Markdowntext;


FUNCTION Build (
   rec_   IN Page_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Page_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.editmode_ IS NOT NULL) THEN
      json_.put('editmode', rec_.editmode_);
   END IF;
   IF (rec_.staticlabel_ IS NOT NULL) THEN
      json_.put('staticlabel', rec_.staticlabel_);
   END IF;
   IF (rec_.additionalcontext_ IS NOT NULL) THEN
      IF (rec_.additionalcontext_ IS NULL) THEN
         json_.put('additionalcontext', JSON_ARRAY_T());
      ELSE
         json_.put('additionalcontext', rec_.additionalcontext_);
      END IF;
   END IF;
   IF (rec_.crudactions_ IS NOT NULL) THEN
      IF (rec_.crudactions_ IS NULL) THEN
         json_.put('crudactions', JSON_OBJECT_T());
      ELSE
         json_.put('crudactions', rec_.crudactions_);
      END IF;
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.entity_ IS NOT NULL) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.searchcontext_ IS NOT NULL) THEN
      IF (rec_.searchcontext_ IS NULL) THEN
         json_.put('searchcontext', JSON_ARRAY_T());
      ELSE
         json_.put('searchcontext', rec_.searchcontext_);
      END IF;
   END IF;
   IF (rec_.ganttchart_ IS NOT NULL) THEN
      IF (rec_.ganttchart_ IS NULL) THEN
         json_.put('ganttchart', JSON_ARRAY_T());
      ELSE
         json_.put('ganttchart', rec_.ganttchart_);
      END IF;
   END IF;
   IF (rec_.defaultfilter_ IS NOT NULL) THEN
      json_.put('defaultfilter', rec_.defaultfilter_);
   END IF;
   IF (rec_.stateindicator_ IS NOT NULL) THEN
      json_.put('stateindicator', rec_.stateindicator_);
   END IF;
   IF (rec_.attachments_ IS NOT NULL) THEN
      IF (rec_.attachments_ IS NULL) THEN
         json_.put('attachments', JSON_OBJECT_T());
      ELSE
         json_.put('attachments', rec_.attachments_);
      END IF;
   END IF;
   IF (rec_.media_ IS NOT NULL) THEN
      IF (rec_.media_ IS NULL) THEN
         json_.put('media', JSON_OBJECT_T());
      ELSE
         json_.put('media', rec_.media_);
      END IF;
   END IF;
   IF (rec_.content_ IS NOT NULL) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   IF (rec_.commands_ IS NOT NULL) THEN
      IF (rec_.commands_ IS NULL) THEN
         json_.put('commands', JSON_ARRAY_T());
      ELSE
         json_.put('commands', rec_.commands_);
      END IF;
   END IF;
   IF (rec_.commandgroups_ IS NOT NULL) THEN
      IF (rec_.commandgroups_ IS NULL) THEN
         json_.put('commandgroups', JSON_ARRAY_T());
      ELSE
         json_.put('commandgroups', rec_.commandgroups_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Editmode (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.editmode_ := value_;
END Set_Editmode;
  
PROCEDURE Set_Staticlabel (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.staticlabel_ := value_;
END Set_Staticlabel;
  
PROCEDURE Add_Additionalcontext (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.additionalcontext_ IS NULL) THEN
      rec_.additionalcontext_ := JSON_ARRAY_T();
   END IF;
   rec_.additionalcontext_.append(value_);
END Add_Additionalcontext;
  

PROCEDURE Set_Crudactions (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            CrudActions_Rec )
IS
BEGIN
   rec_.crudactions_ := Build_Json___(value_);
END Set_Crudactions;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  

PROCEDURE Add_Searchcontext (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            SearchContext_Rec )
IS
BEGIN
   IF (rec_.searchcontext_ IS NULL) THEN
      rec_.searchcontext_ := JSON_ARRAY_T();
   END IF;
   rec_.searchcontext_.append(Build_Json___(value_));
END Add_Searchcontext;

  

PROCEDURE Add_Ganttchart (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            Ganttchart_Rec )
IS
BEGIN
   IF (rec_.ganttchart_ IS NULL) THEN
      rec_.ganttchart_ := JSON_ARRAY_T();
   END IF;
   rec_.ganttchart_.append(Build_Json___(value_));
END Add_Ganttchart;

  
PROCEDURE Set_Defaultfilter (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.defaultfilter_ := value_;
END Set_Defaultfilter;
  
PROCEDURE Set_Stateindicator (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.stateindicator_ := value_;
END Set_Stateindicator;
  

PROCEDURE Set_Attachments (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            Attachments_Rec )
IS
BEGIN
   rec_.attachments_ := Build_Json___(value_);
END Set_Attachments;

  

PROCEDURE Set_Media (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            Media_Rec )
IS
BEGIN
   rec_.media_ := Build_Json___(value_);
END Set_Media;

  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            PiechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            BarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            StackedchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            LinechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            RadarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            GanttchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            GanttchartItemElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            GanttchartRowElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            GanttchartItemStyleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            GanttchartRowIconElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            GanttDependencyElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            GanttchartTimemarkerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            GanttchartScheduleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            GanttchartLegendElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            BoxMatrixElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            CalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            CardElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            DiagramElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            FieldSetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            FileSelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            GroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            InlineGroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            ImageviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            ListElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            MarkdownTextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            PluginElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            ProcessviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            StackedCalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            SelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            SingletonElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            SheetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            SearchContextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            TimelineElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            YearViewElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            Arrange_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            TabsElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;

  
PROCEDURE Add_Commands (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.commands_ IS NULL) THEN
      rec_.commands_ := JSON_ARRAY_T();
   END IF;
   rec_.commands_.append(value_);
END Add_Commands;
  

PROCEDURE Add_Commandgroups (
   rec_   IN OUT NOCOPY Page_Rec,
   value_ IN            CommandGroup_Rec )
IS
BEGIN
   IF (rec_.commandgroups_ IS NULL) THEN
      rec_.commandgroups_ := JSON_ARRAY_T();
   END IF;
   rec_.commandgroups_.append(Build_Json___(value_));
END Add_Commandgroups;


FUNCTION Build (
   rec_   IN Plugin_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Plugin_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.context_ IS NOT NULL) THEN
      json_.put('context', rec_.context_);
   END IF;
   IF (TRUE) THEN
      json_.put('path', rec_.path_);
   END IF;
   IF (rec_.height_ IS NOT NULL) THEN
      json_.put('height', rec_.height_);
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      IF (rec_.collapsed_ = 'TRUE') THEN
         json_.put('collapsed', TRUE);
      ELSIF (rec_.collapsed_ = 'FALSE') THEN
         json_.put('collapsed', FALSE);
      ELSE
         json_.put('collapsed', rec_.collapsed_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Plugin_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY Plugin_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Plugin_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Plugin_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Context (
   rec_   IN OUT NOCOPY Plugin_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.context_ := value_;
END Set_Context;
  
PROCEDURE Set_Path (
   rec_   IN OUT NOCOPY Plugin_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.path_ := value_;
END Set_Path;
  
PROCEDURE Set_Height (
   rec_   IN OUT NOCOPY Plugin_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.height_ := value_;
END Set_Height;
  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Plugin_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;


PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Plugin_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Collapsed;

FUNCTION Build (
   rec_   IN PluginElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN PluginElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'plugin');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('plugin', rec_.plugin_);
   END IF;
   IF (rec_.override_ IS NOT NULL) THEN
      IF (rec_.override_ IS NULL) THEN
         json_.put('override', JSON_OBJECT_T());
      ELSE
         json_.put('override', rec_.override_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY PluginElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY PluginElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY PluginElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Plugin (
   rec_   IN OUT NOCOPY PluginElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.plugin_ := value_;
END Set_Plugin;

  

PROCEDURE Set_Override (
   rec_   IN OUT NOCOPY PluginElement_Rec,
   value_ IN            PluginElementOverride_Rec )
IS
BEGIN
   rec_.override_ := Build_Json___(value_);
END Set_Override;


FUNCTION Build (
   rec_   IN PluginElementOverride_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN PluginElementOverride_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      IF (rec_.collapsed_ = 'TRUE') THEN
         json_.put('collapsed', TRUE);
      ELSIF (rec_.collapsed_ = 'FALSE') THEN
         json_.put('collapsed', FALSE);
      ELSE
         json_.put('collapsed', rec_.collapsed_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY PluginElementOverride_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY PluginElementOverride_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY PluginElementOverride_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;


PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY PluginElementOverride_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Collapsed;

FUNCTION Build (
   rec_   IN Processviewer_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Processviewer_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.activestage_ IS NOT NULL) THEN
      json_.put('activestage', rec_.activestage_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Processviewer_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Processviewer_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Activestage (
   rec_   IN OUT NOCOPY Processviewer_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.activestage_ := value_;
END Set_Activestage;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Processviewer_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;


FUNCTION Build (
   rec_   IN ProcessviewerElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ProcessviewerElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'processviewer');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('processviewer', rec_.processviewer_);
   END IF;
   IF (rec_.content_ IS NOT NULL) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   IF (rec_.override_ IS NOT NULL) THEN
      IF (rec_.override_ IS NULL) THEN
         json_.put('override', JSON_OBJECT_T());
      ELSE
         json_.put('override', rec_.override_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Processviewer (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.processviewer_ := value_;
END Set_Processviewer;

  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            PiechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            BarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            StackedchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            LinechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            RadarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            GanttchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            GanttchartItemElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            GanttchartRowElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            GanttchartItemStyleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            GanttchartRowIconElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            GanttDependencyElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            GanttchartTimemarkerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            GanttchartScheduleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            GanttchartLegendElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            BoxMatrixElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            CalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            CardElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            DiagramElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            FieldSetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            FileSelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            GroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            InlineGroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            ImageviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            ListElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            MarkdownTextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            PluginElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            ProcessviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            StackedCalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            SelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            SingletonElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            SheetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            SearchContextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            TimelineElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            YearViewElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            Arrange_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            TabsElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;

  

PROCEDURE Set_Override (
   rec_   IN OUT NOCOPY ProcessviewerElement_Rec,
   value_ IN            ProcessviewerElementOverride_Rec )
IS
BEGIN
   rec_.override_ := Build_Json___(value_);
END Set_Override;


FUNCTION Build (
   rec_   IN ProcessviewerElementOverride_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ProcessviewerElementOverride_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY ProcessviewerElementOverride_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY ProcessviewerElementOverride_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;

FUNCTION Build (
   rec_   IN StackedCalendar_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN StackedCalendar_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (TRUE) THEN
      json_.put('weekstart', rec_.weekstart_);
   END IF;
   IF (TRUE) THEN
      json_.put('weeklength', rec_.weeklength_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.reports_ IS NULL) THEN
         json_.put('reports', JSON_OBJECT_T());
      ELSE
         json_.put('reports', rec_.reports_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.days_info_ IS NULL) THEN
         json_.put('daysInfo', JSON_OBJECT_T());
      ELSE
         json_.put('daysInfo', rec_.days_info_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.attendance_ IS NULL) THEN
         json_.put('attendance', JSON_OBJECT_T());
      ELSE
         json_.put('attendance', rec_.attendance_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.to_report_ IS NULL) THEN
         json_.put('toReport', JSON_OBJECT_T());
      ELSE
         json_.put('toReport', rec_.to_report_);
      END IF;
   END IF;
   IF (rec_.commands_ IS NOT NULL) THEN
      json_.put('commands', rec_.commands_);
   END IF;
   IF (rec_.commandgroups_ IS NOT NULL) THEN
      IF (rec_.commandgroups_ IS NULL) THEN
         json_.put('commandgroups', JSON_OBJECT_T());
      ELSE
         json_.put('commandgroups', rec_.commandgroups_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY StackedCalendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY StackedCalendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY StackedCalendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY StackedCalendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Weekstart (
   rec_   IN OUT NOCOPY StackedCalendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.weekstart_ := value_;
END Set_Weekstart;
  
PROCEDURE Set_Weeklength (
   rec_   IN OUT NOCOPY StackedCalendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.weeklength_ := value_;
END Set_Weeklength;
  

PROCEDURE Set_Reports (
   rec_   IN OUT NOCOPY StackedCalendar_Rec,
   value_ IN            StackedCalendarReportsArray_Rec )
IS
BEGIN
   rec_.reports_ := Build_Json___(value_);
END Set_Reports;

  

PROCEDURE Set_Days_Info (
   rec_   IN OUT NOCOPY StackedCalendar_Rec,
   value_ IN            StackedCalendarDaysInfoArray_Rec )
IS
BEGIN
   rec_.days_info_ := Build_Json___(value_);
END Set_Days_Info;

  

PROCEDURE Set_Attendance (
   rec_   IN OUT NOCOPY StackedCalendar_Rec,
   value_ IN            StackedCalendarAttendanceArray_Rec )
IS
BEGIN
   rec_.attendance_ := Build_Json___(value_);
END Set_Attendance;

  

PROCEDURE Set_To_Report (
   rec_   IN OUT NOCOPY StackedCalendar_Rec,
   value_ IN            StackedCalendarToReportArray_Rec )
IS
BEGIN
   rec_.to_report_ := Build_Json___(value_);
END Set_To_Report;

  
PROCEDURE Set_Commands (
   rec_   IN OUT NOCOPY StackedCalendar_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.commands_ := value_;
END Set_Commands;
  

PROCEDURE Set_Commandgroups (
   rec_   IN OUT NOCOPY StackedCalendar_Rec,
   value_ IN            CommandGroup_Rec )
IS
BEGIN
   rec_.commandgroups_ := Build_Json___(value_);
END Set_Commandgroups;


FUNCTION Build (
   rec_   IN StackedCalendarReportsArray_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN StackedCalendarReportsArray_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('arrayName', rec_.array_name_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (TRUE) THEN
      json_.put('date', rec_.date_);
   END IF;
   IF (TRUE) THEN
      json_.put('duration', rec_.duration_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.grouping_ IS NULL) THEN
         json_.put('grouping', JSON_OBJECT_T());
      ELSE
         json_.put('grouping', rec_.grouping_);
      END IF;
   END IF;
   IF (rec_.update_command_ IS NOT NULL) THEN
      IF (rec_.update_command_ IS NULL) THEN
         json_.put('updateCommand', JSON_OBJECT_T());
      ELSE
         json_.put('updateCommand', rec_.update_command_);
      END IF;
   END IF;
   IF (rec_.delete_command_ IS NOT NULL) THEN
      IF (rec_.delete_command_ IS NULL) THEN
         json_.put('deleteCommand', JSON_OBJECT_T());
      ELSE
         json_.put('deleteCommand', rec_.delete_command_);
      END IF;
   END IF;
   IF (rec_.create_command_ IS NOT NULL) THEN
      IF (rec_.create_command_ IS NULL) THEN
         json_.put('createCommand', JSON_OBJECT_T());
      ELSE
         json_.put('createCommand', rec_.create_command_);
      END IF;
   END IF;
   IF (rec_.copy_command_ IS NOT NULL) THEN
      IF (rec_.copy_command_ IS NULL) THEN
         json_.put('copyCommand', JSON_OBJECT_T());
      ELSE
         json_.put('copyCommand', rec_.copy_command_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Array_Name (
   rec_   IN OUT NOCOPY StackedCalendarReportsArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.array_name_ := value_;
END Set_Array_Name;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY StackedCalendarReportsArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Date (
   rec_   IN OUT NOCOPY StackedCalendarReportsArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.date_ := value_;
END Set_Date;
  
PROCEDURE Set_Duration (
   rec_   IN OUT NOCOPY StackedCalendarReportsArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.duration_ := value_;
END Set_Duration;
  

PROCEDURE Set_Grouping (
   rec_   IN OUT NOCOPY StackedCalendarReportsArray_Rec,
   value_ IN            StackedCalendarGroupingArray_Rec )
IS
BEGIN
   rec_.grouping_ := Build_Json___(value_);
END Set_Grouping;

  

PROCEDURE Set_Update_Command (
   rec_   IN OUT NOCOPY StackedCalendarReportsArray_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.update_command_ := Build_Json___(value_);
END Set_Update_Command;

  

PROCEDURE Set_Delete_Command (
   rec_   IN OUT NOCOPY StackedCalendarReportsArray_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.delete_command_ := Build_Json___(value_);
END Set_Delete_Command;

  

PROCEDURE Set_Create_Command (
   rec_   IN OUT NOCOPY StackedCalendarReportsArray_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.create_command_ := Build_Json___(value_);
END Set_Create_Command;

  

PROCEDURE Set_Copy_Command (
   rec_   IN OUT NOCOPY StackedCalendarReportsArray_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.copy_command_ := Build_Json___(value_);
END Set_Copy_Command;


FUNCTION Build (
   rec_   IN StackedCalendarGroupingArray_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN StackedCalendarGroupingArray_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('primary', rec_.primary_);
   END IF;
   IF (TRUE) THEN
      json_.put('secondary', rec_.secondary_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Primary (
   rec_   IN OUT NOCOPY StackedCalendarGroupingArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.primary_ := value_;
END Set_Primary;
  
PROCEDURE Set_Secondary (
   rec_   IN OUT NOCOPY StackedCalendarGroupingArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.secondary_ := value_;
END Set_Secondary;

FUNCTION Build (
   rec_   IN StackedCalendarAttendanceArray_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN StackedCalendarAttendanceArray_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('arrayName', rec_.array_name_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (TRUE) THEN
      json_.put('date', rec_.date_);
   END IF;
   IF (TRUE) THEN
      json_.put('duration', rec_.duration_);
   END IF;
   IF (TRUE) THEN
      json_.put('descriptionAttribute', rec_.description_attribute_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.grouping_ IS NULL) THEN
         json_.put('grouping', JSON_OBJECT_T());
      ELSE
         json_.put('grouping', rec_.grouping_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('typeAttribute', rec_.type_attribute_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.report_types_ IS NULL) THEN
         json_.put('reportTypes', JSON_ARRAY_T());
      ELSE
         json_.put('reportTypes', rec_.report_types_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.wage_types_ IS NULL) THEN
         json_.put('wageTypes', JSON_ARRAY_T());
      ELSE
         json_.put('wageTypes', rec_.wage_types_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.wage_types_colors_ IS NULL) THEN
         json_.put('wageTypesColors', JSON_OBJECT_T());
      ELSE
         json_.put('wageTypesColors', rec_.wage_types_colors_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.list_types_ IS NULL) THEN
         json_.put('listTypes', JSON_ARRAY_T());
      ELSE
         json_.put('listTypes', rec_.list_types_);
      END IF;
   END IF;
   IF (rec_.update_command_ IS NOT NULL) THEN
      IF (rec_.update_command_ IS NULL) THEN
         json_.put('updateCommand', JSON_OBJECT_T());
      ELSE
         json_.put('updateCommand', rec_.update_command_);
      END IF;
   END IF;
   IF (rec_.delete_command_ IS NOT NULL) THEN
      IF (rec_.delete_command_ IS NULL) THEN
         json_.put('deleteCommand', JSON_OBJECT_T());
      ELSE
         json_.put('deleteCommand', rec_.delete_command_);
      END IF;
   END IF;
   IF (rec_.create_command_ IS NOT NULL) THEN
      IF (rec_.create_command_ IS NULL) THEN
         json_.put('createCommand', JSON_OBJECT_T());
      ELSE
         json_.put('createCommand', rec_.create_command_);
      END IF;
   END IF;
   IF (rec_.copy_command_ IS NOT NULL) THEN
      IF (rec_.copy_command_ IS NULL) THEN
         json_.put('copyCommand', JSON_OBJECT_T());
      ELSE
         json_.put('copyCommand', rec_.copy_command_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Array_Name (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.array_name_ := value_;
END Set_Array_Name;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Date (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.date_ := value_;
END Set_Date;
  
PROCEDURE Set_Duration (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.duration_ := value_;
END Set_Duration;
  
PROCEDURE Set_Description_Attribute (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.description_attribute_ := value_;
END Set_Description_Attribute;
  

PROCEDURE Set_Grouping (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            StackedCalendarGroupingArray_Rec )
IS
BEGIN
   rec_.grouping_ := Build_Json___(value_);
END Set_Grouping;

  
PROCEDURE Set_Type_Attribute (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.type_attribute_ := value_;
END Set_Type_Attribute;
  
PROCEDURE Add_Report_Types (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.report_types_ IS NULL) THEN
      rec_.report_types_ := JSON_ARRAY_T();
   END IF;
   rec_.report_types_.append(value_);
END Add_Report_Types;
  
PROCEDURE Add_Wage_Types (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.wage_types_ IS NULL) THEN
      rec_.wage_types_ := JSON_ARRAY_T();
   END IF;
   rec_.wage_types_.append(value_);
END Add_Wage_Types;
  

PROCEDURE Set_Wage_Types_Colors (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            Emphasis_Rec )
IS
BEGIN
   rec_.wage_types_colors_ := Build_Json___(value_);
END Set_Wage_Types_Colors;

  
PROCEDURE Add_List_Types (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.list_types_ IS NULL) THEN
      rec_.list_types_ := JSON_ARRAY_T();
   END IF;
   rec_.list_types_.append(value_);
END Add_List_Types;
  

PROCEDURE Set_Update_Command (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.update_command_ := Build_Json___(value_);
END Set_Update_Command;

  

PROCEDURE Set_Delete_Command (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.delete_command_ := Build_Json___(value_);
END Set_Delete_Command;

  

PROCEDURE Set_Create_Command (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.create_command_ := Build_Json___(value_);
END Set_Create_Command;

  

PROCEDURE Set_Copy_Command (
   rec_   IN OUT NOCOPY StackedCalendarAttendanceArray_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.copy_command_ := Build_Json___(value_);
END Set_Copy_Command;


FUNCTION Build (
   rec_   IN StackedCalendarDaysInfoArray_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN StackedCalendarDaysInfoArray_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('arrayName', rec_.array_name_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (TRUE) THEN
      json_.put('date', rec_.date_);
   END IF;
   IF (TRUE) THEN
      json_.put('duration', rec_.duration_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.update_note_command_ IS NULL) THEN
         json_.put('updateNoteCommand', JSON_OBJECT_T());
      ELSE
         json_.put('updateNoteCommand', rec_.update_note_command_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Array_Name (
   rec_   IN OUT NOCOPY StackedCalendarDaysInfoArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.array_name_ := value_;
END Set_Array_Name;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY StackedCalendarDaysInfoArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Date (
   rec_   IN OUT NOCOPY StackedCalendarDaysInfoArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.date_ := value_;
END Set_Date;
  
PROCEDURE Set_Duration (
   rec_   IN OUT NOCOPY StackedCalendarDaysInfoArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.duration_ := value_;
END Set_Duration;
  

PROCEDURE Set_Update_Note_Command (
   rec_   IN OUT NOCOPY StackedCalendarDaysInfoArray_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.update_note_command_ := Build_Json___(value_);
END Set_Update_Note_Command;


FUNCTION Build (
   rec_   IN StackedCalendarToReportArray_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN StackedCalendarToReportArray_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('arrayName', rec_.array_name_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (TRUE) THEN
      json_.put('date', rec_.date_);
   END IF;
   IF (TRUE) THEN
      json_.put('wageLeft', rec_.wage_left_);
   END IF;
   IF (TRUE) THEN
      json_.put('jobLeft', rec_.job_left_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Array_Name (
   rec_   IN OUT NOCOPY StackedCalendarToReportArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.array_name_ := value_;
END Set_Array_Name;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY StackedCalendarToReportArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Date (
   rec_   IN OUT NOCOPY StackedCalendarToReportArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.date_ := value_;
END Set_Date;
  
PROCEDURE Set_Wage_Left (
   rec_   IN OUT NOCOPY StackedCalendarToReportArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.wage_left_ := value_;
END Set_Wage_Left;
  
PROCEDURE Set_Job_Left (
   rec_   IN OUT NOCOPY StackedCalendarToReportArray_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.job_left_ := value_;
END Set_Job_Left;

FUNCTION Build (
   rec_   IN StackedCalendarElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN StackedCalendarElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'stackedCalendar');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('stackedCalendar', rec_.stacked_calendar_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY StackedCalendarElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY StackedCalendarElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY StackedCalendarElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Stacked_Calendar (
   rec_   IN OUT NOCOPY StackedCalendarElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.stacked_calendar_ := value_;
END Set_Stacked_Calendar;


FUNCTION Build (
   rec_   IN SelectorElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN SelectorElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'selector');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('selector', rec_.selector_);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY SelectorElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY SelectorElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Set_Selector (
   rec_   IN OUT NOCOPY SelectorElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.selector_ := value_;
END Set_Selector;

  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY SelectorElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY SelectorElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY SelectorElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN Selector_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Selector_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   IF (rec_.crudactions_ IS NOT NULL) THEN
      IF (rec_.crudactions_ IS NULL) THEN
         json_.put('crudactions', JSON_OBJECT_T());
      ELSE
         json_.put('crudactions', rec_.crudactions_);
      END IF;
   END IF;
   IF (rec_.content_ IS NOT NULL) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   IF (rec_.commands_ IS NOT NULL) THEN
      IF (rec_.commands_ IS NULL) THEN
         json_.put('commands', JSON_ARRAY_T());
      ELSE
         json_.put('commands', rec_.commands_);
      END IF;
   END IF;
   IF (rec_.commandgroups_ IS NOT NULL) THEN
      IF (rec_.commandgroups_ IS NULL) THEN
         json_.put('commandgroups', JSON_ARRAY_T());
      ELSE
         json_.put('commandgroups', rec_.commandgroups_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY Selector_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;
  

PROCEDURE Set_Crudactions (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            CrudActions_Rec )
IS
BEGIN
   rec_.crudactions_ := Build_Json___(value_);
END Set_Crudactions;

  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            PiechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            BarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            StackedchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            LinechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            RadarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            GanttchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            GanttchartItemElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            GanttchartRowElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            GanttchartItemStyleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            GanttchartRowIconElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            GanttDependencyElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            GanttchartTimemarkerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            GanttchartScheduleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            GanttchartLegendElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            BoxMatrixElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            CalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            CardElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            DiagramElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            FieldSetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            FileSelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            GroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            InlineGroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            ImageviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            ListElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            MarkdownTextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            PluginElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            ProcessviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            StackedCalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            SelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            SingletonElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            SheetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            SearchContextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            TimelineElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            YearViewElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            Arrange_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            TabsElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;

  
PROCEDURE Add_Commands (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.commands_ IS NULL) THEN
      rec_.commands_ := JSON_ARRAY_T();
   END IF;
   rec_.commands_.append(value_);
END Add_Commands;
  

PROCEDURE Add_Commandgroups (
   rec_   IN OUT NOCOPY Selector_Rec,
   value_ IN            CommandGroup_Rec )
IS
BEGIN
   IF (rec_.commandgroups_ IS NULL) THEN
      rec_.commandgroups_ := JSON_ARRAY_T();
   END IF;
   rec_.commandgroups_.append(Build_Json___(value_));
END Add_Commandgroups;


FUNCTION Build (
   rec_   IN Singleton_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Singleton_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Singleton_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Singleton_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;


FUNCTION Build (
   rec_   IN SingletonElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN SingletonElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'singleton');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('singleton', rec_.singleton_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY SingletonElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY SingletonElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY SingletonElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Singleton (
   rec_   IN OUT NOCOPY SingletonElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.singleton_ := value_;
END Set_Singleton;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY SingletonElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY SingletonElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN Sheet_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Sheet_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.content_ IS NOT NULL) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Sheet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY Sheet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Sheet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Sheet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Sheet_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Sheet_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


FUNCTION Build (
   rec_   IN SheetElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN SheetElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'sheet');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('sheet', rec_.sheet_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (rec_.override_ IS NOT NULL) THEN
      IF (rec_.override_ IS NULL) THEN
         json_.put('override', JSON_OBJECT_T());
      ELSE
         json_.put('override', rec_.override_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY SheetElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY SheetElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY SheetElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Sheet (
   rec_   IN OUT NOCOPY SheetElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.sheet_ := value_;
END Set_Sheet;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY SheetElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY SheetElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  

PROCEDURE Set_Override (
   rec_   IN OUT NOCOPY SheetElement_Rec,
   value_ IN            Override_Rec )
IS
BEGIN
   rec_.override_ := Build_Json___(value_);
END Set_Override;


FUNCTION Build (
   rec_   IN SearchContext_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN SearchContext_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;
  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            PiechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            BarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            StackedchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            LinechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            RadarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            GanttchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            GanttchartItemElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            GanttchartRowElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            GanttchartItemStyleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            GanttchartRowIconElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            GanttDependencyElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            GanttchartTimemarkerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            GanttchartScheduleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            GanttchartLegendElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            BoxMatrixElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            CalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            CardElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            DiagramElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            FieldSetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            FileSelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            GroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            InlineGroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            ImageviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            ListElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            MarkdownTextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            PluginElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            ProcessviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            StackedCalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            SelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            SingletonElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            SheetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            SearchContextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            TimelineElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            YearViewElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            Arrange_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY SearchContext_Rec,
   value_ IN            TabsElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


FUNCTION Build (
   rec_   IN SearchContextElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN SearchContextElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'searchcontext');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('searchcontext', rec_.searchcontext_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY SearchContextElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY SearchContextElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY SearchContextElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Searchcontext (
   rec_   IN OUT NOCOPY SearchContextElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.searchcontext_ := value_;
END Set_Searchcontext;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY SearchContextElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY SearchContextElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;


FUNCTION Build (
   rec_   IN StateIndicator_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN StateIndicator_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.entity_ IS NOT NULL) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (TRUE) THEN
      json_.put('control', rec_.control_);
   END IF;
   IF (rec_.stateattribute_ IS NOT NULL) THEN
      json_.put('stateattribute', rec_.stateattribute_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.states_ IS NULL) THEN
         json_.put('states', JSON_ARRAY_T());
      ELSE
         json_.put('states', rec_.states_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY StateIndicator_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY StateIndicator_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Control (
   rec_   IN OUT NOCOPY StateIndicator_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.control_ := value_;
END Set_Control;
  

PROCEDURE Set_Stateattribute (
   rec_   IN OUT NOCOPY StateIndicator_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.stateattribute_ := value_;
END Set_Stateattribute;

  

PROCEDURE Add_States (
   rec_   IN OUT NOCOPY StateIndicator_Rec,
   value_ IN            State_Rec )
IS
BEGIN
   IF (rec_.states_ IS NULL) THEN
      rec_.states_ := JSON_ARRAY_T();
   END IF;
   rec_.states_.append(Build_Json___(value_));
END Add_States;


FUNCTION Build (
   rec_   IN State_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN State_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   IF (rec_.completed_ IS NOT NULL) THEN
      json_.put('completed', rec_.completed_);
   END IF;
   IF (rec_.group_ IS NOT NULL) THEN
      IF (rec_.group_ IS NULL) THEN
         json_.put('group', JSON_ARRAY_T());
      ELSE
         json_.put('group', rec_.group_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY State_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY State_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;
  

PROCEDURE Set_Completed (
   rec_   IN OUT NOCOPY State_Rec,
   value_ IN            NUMBER )
IS
BEGIN
   rec_.completed_ := value_;
END Set_Completed;

  
PROCEDURE Add_Group (
   rec_   IN OUT NOCOPY State_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.group_ IS NULL) THEN
      rec_.group_ := JSON_ARRAY_T();
   END IF;
   rec_.group_.append(value_);
END Add_Group;

FUNCTION Build (
   rec_   IN Timeline_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Timeline_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      IF (rec_.collapsed_ = 'TRUE') THEN
         json_.put('collapsed', TRUE);
      ELSIF (rec_.collapsed_ = 'FALSE') THEN
         json_.put('collapsed', FALSE);
      ELSE
         json_.put('collapsed', rec_.collapsed_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.orderby_ IS NOT NULL) THEN
      IF (rec_.orderby_ IS NULL) THEN
         json_.put('orderby', JSON_ARRAY_T());
      ELSE
         json_.put('orderby', rec_.orderby_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('timefield', rec_.timefield_);
   END IF;
   IF (rec_.header_ IS NOT NULL) THEN
      json_.put('header', rec_.header_);
   END IF;
   IF (rec_.description_ IS NOT NULL) THEN
      json_.put('description', rec_.description_);
   END IF;
   IF (rec_.contact_widget_ IS NOT NULL) THEN
      IF (rec_.contact_widget_ IS NULL) THEN
         json_.put('contactWidget', JSON_OBJECT_T());
      ELSE
         json_.put('contactWidget', rec_.contact_widget_);
      END IF;
   END IF;
   IF (rec_.show_year_ IS NOT NULL) THEN
      json_.put('showYear', rec_.show_year_);
   END IF;
   IF (rec_.show_month_ IS NOT NULL) THEN
      json_.put('showMonth', rec_.show_month_);
   END IF;
   IF (rec_.card_ IS NOT NULL) THEN
      json_.put('card', rec_.card_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   IF (rec_.legends_ IS NOT NULL) THEN
      IF (rec_.legends_ IS NULL) THEN
         json_.put('legends', JSON_ARRAY_T());
      ELSE
         json_.put('legends', rec_.legends_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;


PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Collapsed;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Add_Orderby (
   rec_   IN OUT NOCOPY Timeline_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.orderby_ IS NULL) THEN
      rec_.orderby_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.orderby_.append(obj_);
END Add_Orderby;
  
PROCEDURE Set_Timefield (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.timefield_ := value_;
END Set_Timefield;
  
PROCEDURE Set_Header (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.header_ := value_;
END Set_Header;
  
PROCEDURE Set_Description (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.description_ := value_;
END Set_Description;
  

PROCEDURE Set_Contact_Widget (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            ContactWidget_Rec )
IS
BEGIN
   rec_.contact_widget_ := Build_Json___(value_);
END Set_Contact_Widget;

  
PROCEDURE Set_Show_Year (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.show_year_ := value_;
END Set_Show_Year;
  
PROCEDURE Set_Show_Month (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.show_month_ := value_;
END Set_Show_Month;
  

PROCEDURE Set_Card (
   rec_   IN OUT NOCOPY Timeline_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.card_ := value_;
END Set_Card;

  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY Timeline_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;
  
PROCEDURE Add_Legends (
   rec_   IN OUT NOCOPY Timeline_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.legends_ IS NULL) THEN
      rec_.legends_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.legends_.append(obj_);
END Add_Legends;

FUNCTION Build (
   rec_   IN TimelineElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN TimelineElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'timeline');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('timeline', rec_.timeline_);
   END IF;
   IF (rec_.datasource_ IS NOT NULL) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (rec_.detail_page_ IS NOT NULL) THEN
      json_.put('detailPage', rec_.detail_page_);
   END IF;
   IF (rec_.override_ IS NOT NULL) THEN
      IF (rec_.override_ IS NULL) THEN
         json_.put('override', JSON_OBJECT_T());
      ELSE
         json_.put('override', rec_.override_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY TimelineElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY TimelineElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY TimelineElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Timeline (
   rec_   IN OUT NOCOPY TimelineElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.timeline_ := value_;
END Set_Timeline;

  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY TimelineElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY TimelineElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  
PROCEDURE Set_Detail_Page (
   rec_   IN OUT NOCOPY TimelineElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.detail_page_ := value_;
END Set_Detail_Page;
  

PROCEDURE Set_Override (
   rec_   IN OUT NOCOPY TimelineElement_Rec,
   value_ IN            Override_Rec )
IS
BEGIN
   rec_.override_ := Build_Json___(value_);
END Set_Override;


FUNCTION Build (
   rec_   IN YearView_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN YearView_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (TRUE) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   IF (rec_.schedule_ IS NOT NULL) THEN
      IF (rec_.schedule_ IS NULL) THEN
         json_.put('schedule', JSON_OBJECT_T());
      ELSE
         json_.put('schedule', rec_.schedule_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.resources_ IS NULL) THEN
         json_.put('resources', JSON_OBJECT_T());
      ELSE
         json_.put('resources', rec_.resources_);
      END IF;
   END IF;
   IF (rec_.commands_ IS NOT NULL) THEN
      IF (rec_.commands_ IS NULL) THEN
         json_.put('commands', JSON_ARRAY_T());
      ELSE
         json_.put('commands', rec_.commands_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY YearView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY YearView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY YearView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY YearView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY YearView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY YearView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY YearView_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;
  

PROCEDURE Set_Schedule (
   rec_   IN OUT NOCOPY YearView_Rec,
   value_ IN            CalendarSchedule_Rec )
IS
BEGIN
   rec_.schedule_ := Build_Json___(value_);
END Set_Schedule;

  

PROCEDURE Add_Resources (
   rec_   IN OUT NOCOPY YearView_Rec,
   name_  IN            VARCHAR2,
   value_ IN            CalendarResource_Rec )
IS
BEGIN
   IF (rec_.resources_ IS NULL) THEN
      rec_.resources_ := JSON_OBJECT_T();
   END IF;
   rec_.resources_.put(name_, Build_Json___(value_));
END Add_Resources;

  
PROCEDURE Add_Commands (
   rec_   IN OUT NOCOPY YearView_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.commands_ IS NULL) THEN
      rec_.commands_ := JSON_ARRAY_T();
   END IF;
   rec_.commands_.append(value_);
END Add_Commands;

FUNCTION Build (
   rec_   IN YearViewElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN YearViewElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'yearview');
   END IF;
   IF (TRUE) THEN
      json_.put('isReference', TRUE);
   END IF;
   IF (TRUE) THEN
      json_.put('id', rec_.id_);
   END IF;
   IF (TRUE) THEN
      json_.put('yearview', rec_.yearview_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (rec_.detail_page_ IS NOT NULL) THEN
      json_.put('detailPage', rec_.detail_page_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY YearViewElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY YearViewElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Id (
   rec_   IN OUT NOCOPY YearViewElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.id_ := value_;
END Set_Id;
  

PROCEDURE Set_Yearview (
   rec_   IN OUT NOCOPY YearViewElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.yearview_ := value_;
END Set_Yearview;

  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY YearViewElement_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  
PROCEDURE Set_Detail_Page (
   rec_   IN OUT NOCOPY YearViewElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.detail_page_ := value_;
END Set_Detail_Page;

FUNCTION Build (
   rec_   IN Command_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Command_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.binding_ IS NOT NULL) THEN
      IF (rec_.binding_ IS NULL) THEN
         json_.put('binding', JSON_OBJECT_T());
      ELSE
         json_.put('binding', rec_.binding_);
      END IF;
   END IF;
   IF (rec_.structure_ IS NOT NULL) THEN
      json_.put('structure', rec_.structure_);
   END IF;
   IF (rec_.entity_ IS NOT NULL) THEN
      json_.put('entity', rec_.entity_);
   END IF;
   IF (rec_.select_attributes_ IS NOT NULL) THEN
      IF (rec_.select_attributes_ IS NULL) THEN
         json_.put('selectAttributes', JSON_ARRAY_T());
      ELSE
         json_.put('selectAttributes', rec_.select_attributes_);
      END IF;
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   IF (rec_.icon_ IS NOT NULL) THEN
      json_.put('icon', rec_.icon_);
   END IF;
   IF (rec_.style_ IS NOT NULL) THEN
      json_.put('style', rec_.style_);
   END IF;
   IF (rec_.selection_ IS NOT NULL) THEN
      json_.put('selection', rec_.selection_);
   END IF;
   IF (rec_.enabled_ IS NOT NULL) THEN
      IF (rec_.enabled_ = 'TRUE') THEN
         json_.put('enabled', TRUE);
      ELSIF (rec_.enabled_ = 'FALSE') THEN
         json_.put('enabled', FALSE);
      ELSE
         json_.put('enabled', rec_.enabled_);
      END IF;
   END IF;
   IF (rec_.autosave_ IS NOT NULL) THEN
      IF (rec_.autosave_ = 'TRUE') THEN
         json_.put('autosave', TRUE);
      ELSIF (rec_.autosave_ = 'FALSE') THEN
         json_.put('autosave', FALSE);
      ELSE
         json_.put('autosave', rec_.autosave_);
      END IF;
   END IF;
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   IF (TRUE) THEN
      IF (rec_.vars_ IS NULL) THEN
         json_.put('vars', JSON_OBJECT_T());
      ELSE
         json_.put('vars', rec_.vars_);
      END IF;
   END IF;
   IF (rec_.context_ IS NOT NULL) THEN
      json_.put('context', rec_.context_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.execute_ IS NULL) THEN
         json_.put('execute', JSON_ARRAY_T());
      ELSE
         json_.put('execute', rec_.execute_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Set_Binding (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            Binding_Rec )
IS
BEGIN
   rec_.binding_ := Build_Json___(value_);
END Set_Binding;

  

PROCEDURE Set_Structure (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.structure_ := value_;
END Set_Structure;

  

PROCEDURE Set_Entity (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.entity_ := value_;
END Set_Entity;

  
PROCEDURE Add_Select_Attributes (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.select_attributes_ IS NULL) THEN
      rec_.select_attributes_ := JSON_ARRAY_T();
   END IF;
   rec_.select_attributes_.append(value_);
END Add_Select_Attributes;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY Command_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;
  
PROCEDURE Set_Icon (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.icon_ := value_;
END Set_Icon;
  
PROCEDURE Set_Style (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.style_ := value_;
END Set_Style;
  
PROCEDURE Set_Selection (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.selection_ := value_;
END Set_Selection;
  
PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.enabled_ := value_;
END Set_Enabled;


PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.enabled_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Enabled;
  
PROCEDURE Set_Autosave (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.autosave_ := value_;
END Set_Autosave;


PROCEDURE Set_Autosave (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.autosave_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Autosave;
  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;
  

PROCEDURE Add_Vars (
   rec_   IN OUT NOCOPY Command_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Variable_Rec )
IS
BEGIN
   IF (rec_.vars_ IS NULL) THEN
      rec_.vars_ := JSON_OBJECT_T();
   END IF;
   rec_.vars_.put(name_, Build_Json___(value_));
END Add_Vars;

  
PROCEDURE Set_Context (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.context_ := value_;
END Set_Context;
  

PROCEDURE Add_Execute (
   rec_   IN OUT NOCOPY Command_Rec,
   value_ IN            Execute_Rec )
IS
BEGIN
   IF (rec_.execute_ IS NULL) THEN
      rec_.execute_ := JSON_ARRAY_T();
   END IF;
   rec_.execute_.append(Build_Json___(value_));
END Add_Execute;


FUNCTION Build (
   rec_   IN Variable_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Variable_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('datatype', rec_.datatype_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Datatype (
   rec_   IN OUT NOCOPY Variable_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datatype_ := value_;
END Set_Datatype;

FUNCTION Build (
   rec_   IN Execute_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Executearray_Rec ) RETURN JSON_ARRAY_T
IS
   json_ JSON_ARRAY_T;
BEGIN
   json_ := JSON_ARRAY_T();
   FOR i IN rec_.first .. rec_.last LOOP
      json_.append(Build_Json___(rec_(i)));
   END LOOP;
   RETURN json_;
END Build_Json___;


FUNCTION Build_Json___ (
   rec_   IN Execute_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.call_ IS NULL) THEN
         json_.put('call', JSON_OBJECT_T());
      ELSE
         json_.put('call', rec_.call_);
      END IF;
   END IF;
   IF (rec_.result_ IS NOT NULL) THEN
      IF (rec_.result_ IS NULL) THEN
         json_.put('result', JSON_OBJECT_T());
      ELSE
         json_.put('result', rec_.result_);
      END IF;
   END IF;
   IF (rec_.assign_ IS NOT NULL) THEN
      json_.put('assign', rec_.assign_);
   END IF;
   IF (rec_.next_ IS NOT NULL) THEN
      IF (rec_.next_ IS NULL) THEN
         json_.put('next', JSON_OBJECT_T());
      ELSE
         json_.put('next', rec_.next_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Call (
   rec_   IN OUT NOCOPY Execute_Rec,
   value_ IN            Method_Rec )
IS
BEGIN
   rec_.call_ := Build_Json___(value_);
END Set_Call;

  

PROCEDURE Add_Result (
   rec_   IN OUT NOCOPY Execute_Rec,
   name_  IN            VARCHAR2,
   value_ IN            Executearray_Rec )
IS
BEGIN
   IF (rec_.result_ IS NULL) THEN
      rec_.result_ := JSON_OBJECT_T();
   END IF;
   rec_.result_.put(name_, Build_Json___(value_));
END Add_Result;

  
PROCEDURE Set_Assign (
   rec_   IN OUT NOCOPY Execute_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.assign_ := value_;
END Set_Assign;
  

PROCEDURE Set_Next (
   rec_   IN OUT NOCOPY Execute_Rec,
   value_ IN            Execute_Rec )
IS
BEGIN
   rec_.next_ := Build_Json___(value_);
END Set_Next;


FUNCTION Build (
   rec_   IN Method_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Method_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('method', rec_.method_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.args_ IS NULL) THEN
         json_.put('args', JSON_OBJECT_T());
      ELSE
         json_.put('args', rec_.args_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Method (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.method_ := value_;
END Set_Method;
  

PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            AlertArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            ConfirmArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            InquireArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            LogArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            PrintDialogArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            ToastArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            StringifyArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            SetArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            BulkSetArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            ExitArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            RefreshArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            IfArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            EveryArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            SomeArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            NavigateArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            BulkNavigateArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            DownloadArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            UploadArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            PinArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            BulkPinArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            UnpinArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            SelectArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            ActionArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            FunctionArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            BulkActionArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            BulkFunctionArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            TransferArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            ReceiveArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            DialogArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            AssistantArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


PROCEDURE Set_Args (
   rec_   IN OUT NOCOPY Method_Rec,
   value_ IN            PrintArgs_Rec )
IS
BEGIN
   rec_.args_ := Build_Json___(value_);
END Set_Args;


FUNCTION Build (
   rec_   IN AlertArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN AlertArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('msg', rec_.msg_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Msg (
   rec_   IN OUT NOCOPY AlertArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.msg_ := value_;
END Set_Msg;

FUNCTION Build (
   rec_   IN ConfirmArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ConfirmArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('msg', rec_.msg_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Msg (
   rec_   IN OUT NOCOPY ConfirmArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.msg_ := value_;
END Set_Msg;

FUNCTION Build (
   rec_   IN InquireArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN InquireArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('msg', rec_.msg_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Msg (
   rec_   IN OUT NOCOPY InquireArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.msg_ := value_;
END Set_Msg;

FUNCTION Build (
   rec_   IN LogArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN LogArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('msg', rec_.msg_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Msg (
   rec_   IN OUT NOCOPY LogArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.msg_ := value_;
END Set_Msg;

FUNCTION Build (
   rec_   IN PrintDialogArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN PrintDialogArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('resultkey', rec_.resultkey_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Resultkey (
   rec_   IN OUT NOCOPY PrintDialogArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.resultkey_ := value_;
END Set_Resultkey;

FUNCTION Build (
   rec_   IN ToastArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ToastArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('type', rec_.type_);
   END IF;
   IF (TRUE) THEN
      json_.put('msg', rec_.msg_);
   END IF;
   IF (rec_.title_ IS NOT NULL) THEN
      json_.put('title', rec_.title_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Type (
   rec_   IN OUT NOCOPY ToastArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.type_ := value_;
END Set_Type;
  
PROCEDURE Set_Msg (
   rec_   IN OUT NOCOPY ToastArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.msg_ := value_;
END Set_Msg;
  
PROCEDURE Set_Title (
   rec_   IN OUT NOCOPY ToastArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.title_ := value_;
END Set_Title;

FUNCTION Build (
   rec_   IN StringifyArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN StringifyArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('source', rec_.source_);
   END IF;
   IF (TRUE) THEN
      json_.put('list', rec_.list_);
   END IF;
   IF (TRUE) THEN
      json_.put('value', rec_.value_);
   END IF;
   IF (TRUE) THEN
      json_.put('assign', rec_.assign_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Source (
   rec_   IN OUT NOCOPY StringifyArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.source_ := value_;
END Set_Source;
  
PROCEDURE Set_List (
   rec_   IN OUT NOCOPY StringifyArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.list_ := value_;
END Set_List;
  
PROCEDURE Set_Value (
   rec_   IN OUT NOCOPY StringifyArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.value_ := value_;
END Set_Value;
  
PROCEDURE Set_Assign (
   rec_   IN OUT NOCOPY StringifyArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.assign_ := value_;
END Set_Assign;

FUNCTION Build (
   rec_   IN SetArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN SetArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.name_ IS NOT NULL) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.original_ IS NOT NULL) THEN
      json_.put('original', rec_.original_);
   END IF;
   IF (rec_.value_ IS NOT NULL) THEN
      IF (rec_.value_ = 'TRUE') THEN
         json_.put('value', TRUE);
      ELSIF (rec_.value_ = 'FALSE') THEN
         json_.put('value', FALSE);
      ELSE
         --TODO: Number datatype set as text, should be a number
         json_.put('value', rec_.value_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY SetArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Original (
   rec_   IN OUT NOCOPY SetArgs_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.original_ := value_;
END Set_Original;
  
PROCEDURE Set_Value (
   rec_   IN OUT NOCOPY SetArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.value_ := value_;
END Set_Value;

FUNCTION Build (
   rec_   IN BulkSetArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BulkSetArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.name_ IS NOT NULL) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.original_ IS NOT NULL) THEN
      json_.put('original', rec_.original_);
   END IF;
   IF (rec_.value_ IS NOT NULL) THEN
      json_.put('value', rec_.value_);
   END IF;
   IF (rec_.attribute_ IS NOT NULL) THEN
      json_.put('attribute', rec_.attribute_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY BulkSetArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Original (
   rec_   IN OUT NOCOPY BulkSetArgs_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.original_ := value_;
END Set_Original;
  
PROCEDURE Set_Value (
   rec_   IN OUT NOCOPY BulkSetArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.value_ := value_;
END Set_Value;
  
PROCEDURE Set_Attribute (
   rec_   IN OUT NOCOPY BulkSetArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.attribute_ := value_;
END Set_Attribute;

FUNCTION Build (
   rec_   IN ExitArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ExitArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.return_ IS NOT NULL) THEN
      json_.put('return', rec_.return_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Return (
   rec_   IN OUT NOCOPY ExitArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.return_ := value_;
END Set_Return;

FUNCTION Build (
   rec_   IN RefreshArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN RefreshArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('projection', rec_.projection_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Projection (
   rec_   IN OUT NOCOPY RefreshArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.projection_ := value_;
END Set_Projection;

FUNCTION Build (
   rec_   IN IfArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN IfArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('expression', rec_.expression_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Expression (
   rec_   IN OUT NOCOPY IfArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.expression_ := value_;
END Set_Expression;

FUNCTION Build (
   rec_   IN EveryArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN EveryArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('expression', rec_.expression_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Expression (
   rec_   IN OUT NOCOPY EveryArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.expression_ := value_;
END Set_Expression;

FUNCTION Build (
   rec_   IN SomeArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN SomeArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('expression', rec_.expression_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Expression (
   rec_   IN OUT NOCOPY SomeArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.expression_ := value_;
END Set_Expression;

FUNCTION Build (
   rec_   IN NavigateArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN NavigateArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('url', rec_.url_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Url (
   rec_   IN OUT NOCOPY NavigateArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.url_ := value_;
END Set_Url;

FUNCTION Build (
   rec_   IN BulkNavigateArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BulkNavigateArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('url', rec_.url_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Url (
   rec_   IN OUT NOCOPY BulkNavigateArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.url_ := value_;
END Set_Url;

FUNCTION Build (
   rec_   IN DownloadArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DownloadArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('url', rec_.url_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Url (
   rec_   IN OUT NOCOPY DownloadArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.url_ := value_;
END Set_Url;

FUNCTION Build (
   rec_   IN UploadArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN UploadArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.call_ IS NOT NULL) THEN
      json_.put('call', rec_.call_);
   END IF;
   IF (TRUE) THEN
      json_.put('url', rec_.url_);
   END IF;
   IF (rec_.fileselector_ IS NOT NULL) THEN
      json_.put('fileselector', rec_.fileselector_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Call (
   rec_   IN OUT NOCOPY UploadArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.call_ := value_;
END Set_Call;
  
PROCEDURE Set_Url (
   rec_   IN OUT NOCOPY UploadArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.url_ := value_;
END Set_Url;
  
PROCEDURE Set_Fileselector (
   rec_   IN OUT NOCOPY UploadArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.fileselector_ := value_;
END Set_Fileselector;

FUNCTION Build (
   rec_   IN PinArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN PinArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('keyref', rec_.keyref_);
   END IF;
   IF (TRUE) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Keyref (
   rec_   IN OUT NOCOPY PinArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.keyref_ := value_;
END Set_Keyref;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY PinArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;

FUNCTION Build (
   rec_   IN BulkPinArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BulkPinArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('keyref', rec_.keyref_);
   END IF;
   IF (TRUE) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Keyref (
   rec_   IN OUT NOCOPY BulkPinArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.keyref_ := value_;
END Set_Keyref;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY BulkPinArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;

FUNCTION Build (
   rec_   IN UnpinArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN UnpinArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('keyref', rec_.keyref_);
   END IF;
   IF (TRUE) THEN
      json_.put('datasource', rec_.datasource_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Keyref (
   rec_   IN OUT NOCOPY UnpinArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.keyref_ := value_;
END Set_Keyref;
  
PROCEDURE Set_Datasource (
   rec_   IN OUT NOCOPY UnpinArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.datasource_ := value_;
END Set_Datasource;

FUNCTION Build (
   rec_   IN SelectArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN SelectArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('selection', rec_.selection_);
   END IF;
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Selection (
   rec_   IN OUT NOCOPY SelectArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.selection_ := value_;
END Set_Selection;
  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY SelectArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;

FUNCTION Build (
   rec_   IN ActionArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ActionArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('projection', rec_.projection_);
   END IF;
   IF (TRUE) THEN
      json_.put('bound', rec_.bound_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.params_ IS NULL) THEN
         json_.put('params', JSON_OBJECT_T());
      ELSE
         json_.put('params', rec_.params_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY ActionArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Projection (
   rec_   IN OUT NOCOPY ActionArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.projection_ := value_;
END Set_Projection;
  
PROCEDURE Set_Bound (
   rec_   IN OUT NOCOPY ActionArgs_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.bound_ := value_;
END Set_Bound;
  

PROCEDURE Add_Params (
   rec_   IN OUT NOCOPY ActionArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.params_ IS NULL) THEN
      rec_.params_ := JSON_OBJECT_T();
   END IF;
   rec_.params_.put(name_, value_);
END Add_Params;


PROCEDURE Add_Params (
   rec_   IN OUT NOCOPY ActionArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            NUMBER )
IS
BEGIN
   IF (rec_.params_ IS NULL) THEN
      rec_.params_ := JSON_OBJECT_T();
   END IF;
   rec_.params_.put(name_, value_);
END Add_Params;


PROCEDURE Add_Params (
   rec_   IN OUT NOCOPY ActionArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            BOOLEAN )
IS
BEGIN
   IF (rec_.params_ IS NULL) THEN
      rec_.params_ := JSON_OBJECT_T();
   END IF;
   rec_.params_.put(name_, value_);
END Add_Params;


FUNCTION Build (
   rec_   IN FunctionArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN FunctionArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('projection', rec_.projection_);
   END IF;
   IF (TRUE) THEN
      json_.put('bound', rec_.bound_);
   END IF;
   IF (rec_.assign_ IS NOT NULL) THEN
      json_.put('assign', rec_.assign_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY FunctionArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Projection (
   rec_   IN OUT NOCOPY FunctionArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.projection_ := value_;
END Set_Projection;
  
PROCEDURE Set_Bound (
   rec_   IN OUT NOCOPY FunctionArgs_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.bound_ := value_;
END Set_Bound;
  
PROCEDURE Set_Assign (
   rec_   IN OUT NOCOPY FunctionArgs_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.assign_ := value_;
END Set_Assign;

FUNCTION Build (
   rec_   IN BulkActionArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BulkActionArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('projection', rec_.projection_);
   END IF;
   IF (TRUE) THEN
      json_.put('bound', rec_.bound_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.params_ IS NULL) THEN
         json_.put('params', JSON_OBJECT_T());
      ELSE
         json_.put('params', rec_.params_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY BulkActionArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Projection (
   rec_   IN OUT NOCOPY BulkActionArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.projection_ := value_;
END Set_Projection;
  
PROCEDURE Set_Bound (
   rec_   IN OUT NOCOPY BulkActionArgs_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.bound_ := value_;
END Set_Bound;
  

PROCEDURE Add_Params (
   rec_   IN OUT NOCOPY BulkActionArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.params_ IS NULL) THEN
      rec_.params_ := JSON_OBJECT_T();
   END IF;
   rec_.params_.put(name_, value_);
END Add_Params;


PROCEDURE Add_Params (
   rec_   IN OUT NOCOPY BulkActionArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            NUMBER )
IS
BEGIN
   IF (rec_.params_ IS NULL) THEN
      rec_.params_ := JSON_OBJECT_T();
   END IF;
   rec_.params_.put(name_, value_);
END Add_Params;


PROCEDURE Add_Params (
   rec_   IN OUT NOCOPY BulkActionArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            BOOLEAN )
IS
BEGIN
   IF (rec_.params_ IS NULL) THEN
      rec_.params_ := JSON_OBJECT_T();
   END IF;
   rec_.params_.put(name_, value_);
END Add_Params;


FUNCTION Build (
   rec_   IN BulkFunctionArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN BulkFunctionArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('projection', rec_.projection_);
   END IF;
   IF (TRUE) THEN
      json_.put('bound', rec_.bound_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY BulkFunctionArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Projection (
   rec_   IN OUT NOCOPY BulkFunctionArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.projection_ := value_;
END Set_Projection;
  
PROCEDURE Set_Bound (
   rec_   IN OUT NOCOPY BulkFunctionArgs_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.bound_ := value_;
END Set_Bound;

FUNCTION Build (
   rec_   IN TransferArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN TransferArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.params_array_ IS NULL) THEN
         json_.put('paramsArray', JSON_ARRAY_T());
      ELSE
         json_.put('paramsArray', rec_.params_array_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Add_Params_Array (
   rec_   IN OUT NOCOPY TransferArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.params_array_ IS NULL) THEN
      rec_.params_array_ := JSON_ARRAY_T();
   END IF;
   rec_.params_array_.append(value_);
END Add_Params_Array;

FUNCTION Build (
   rec_   IN ReceiveArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN ReceiveArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.params_array_ IS NULL) THEN
         json_.put('paramsArray', JSON_ARRAY_T());
      ELSE
         json_.put('paramsArray', rec_.params_array_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Add_Params_Array (
   rec_   IN OUT NOCOPY ReceiveArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.params_array_ IS NULL) THEN
      rec_.params_array_ := JSON_ARRAY_T();
   END IF;
   rec_.params_array_.append(value_);
END Add_Params_Array;

FUNCTION Build (
   rec_   IN DialogArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN DialogArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.input_ IS NOT NULL) THEN
      IF (rec_.input_ IS NULL) THEN
         json_.put('input', JSON_OBJECT_T());
      ELSE
         json_.put('input', rec_.input_);
      END IF;
   END IF;
   IF (rec_.output_ IS NOT NULL) THEN
      IF (rec_.output_ IS NULL) THEN
         json_.put('output', JSON_OBJECT_T());
      ELSE
         json_.put('output', rec_.output_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('projection', rec_.projection_);
   END IF;
   IF (TRUE) THEN
      json_.put('client', rec_.client_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY DialogArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Input (
   rec_   IN OUT NOCOPY DialogArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.input_ IS NULL) THEN
      rec_.input_ := JSON_OBJECT_T();
   END IF;
   rec_.input_.put(name_, value_);
END Add_Input;


PROCEDURE Add_Input (
   rec_   IN OUT NOCOPY DialogArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            NUMBER )
IS
BEGIN
   IF (rec_.input_ IS NULL) THEN
      rec_.input_ := JSON_OBJECT_T();
   END IF;
   rec_.input_.put(name_, value_);
END Add_Input;


PROCEDURE Add_Input (
   rec_   IN OUT NOCOPY DialogArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            BOOLEAN )
IS
BEGIN
   IF (rec_.input_ IS NULL) THEN
      rec_.input_ := JSON_OBJECT_T();
   END IF;
   rec_.input_.put(name_, value_);
END Add_Input;

  

PROCEDURE Add_Output (
   rec_   IN OUT NOCOPY DialogArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.output_ IS NULL) THEN
      rec_.output_ := JSON_OBJECT_T();
   END IF;
   rec_.output_.put(name_, value_);
END Add_Output;


PROCEDURE Add_Output (
   rec_   IN OUT NOCOPY DialogArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            NUMBER )
IS
BEGIN
   IF (rec_.output_ IS NULL) THEN
      rec_.output_ := JSON_OBJECT_T();
   END IF;
   rec_.output_.put(name_, value_);
END Add_Output;


PROCEDURE Add_Output (
   rec_   IN OUT NOCOPY DialogArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            BOOLEAN )
IS
BEGIN
   IF (rec_.output_ IS NULL) THEN
      rec_.output_ := JSON_OBJECT_T();
   END IF;
   rec_.output_.put(name_, value_);
END Add_Output;

  
PROCEDURE Set_Projection (
   rec_   IN OUT NOCOPY DialogArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.projection_ := value_;
END Set_Projection;
  
PROCEDURE Set_Client (
   rec_   IN OUT NOCOPY DialogArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.client_ := value_;
END Set_Client;

FUNCTION Build (
   rec_   IN AssistantArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN AssistantArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.input_ IS NOT NULL) THEN
      IF (rec_.input_ IS NULL) THEN
         json_.put('input', JSON_OBJECT_T());
      ELSE
         json_.put('input', rec_.input_);
      END IF;
   END IF;
   IF (rec_.output_ IS NOT NULL) THEN
      IF (rec_.output_ IS NULL) THEN
         json_.put('output', JSON_OBJECT_T());
      ELSE
         json_.put('output', rec_.output_);
      END IF;
   END IF;
   IF (TRUE) THEN
      json_.put('projection', rec_.projection_);
   END IF;
   IF (TRUE) THEN
      json_.put('client', rec_.client_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY AssistantArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Input (
   rec_   IN OUT NOCOPY AssistantArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.input_ IS NULL) THEN
      rec_.input_ := JSON_OBJECT_T();
   END IF;
   rec_.input_.put(name_, value_);
END Add_Input;

  

PROCEDURE Add_Output (
   rec_   IN OUT NOCOPY AssistantArgs_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.output_ IS NULL) THEN
      rec_.output_ := JSON_OBJECT_T();
   END IF;
   rec_.output_.put(name_, value_);
END Add_Output;

  
PROCEDURE Set_Projection (
   rec_   IN OUT NOCOPY AssistantArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.projection_ := value_;
END Set_Projection;
  
PROCEDURE Set_Client (
   rec_   IN OUT NOCOPY AssistantArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.client_ := value_;
END Set_Client;

FUNCTION Build (
   rec_   IN PrintArgs_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN PrintArgs_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('client', rec_.client_);
   END IF;
   IF (TRUE) THEN
      json_.put('page', rec_.page_);
   END IF;
   IF (rec_.filters_ IS NOT NULL) THEN
      IF (rec_.filters_ IS NULL) THEN
         json_.put('filters', JSON_ARRAY_T());
      ELSE
         json_.put('filters', rec_.filters_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Client (
   rec_   IN OUT NOCOPY PrintArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.client_ := value_;
END Set_Client;
  
PROCEDURE Set_Page (
   rec_   IN OUT NOCOPY PrintArgs_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.page_ := value_;
END Set_Page;
  

PROCEDURE Add_Filters (
   rec_   IN OUT NOCOPY PrintArgs_Rec,
   value_ IN            PrintFilter_Rec )
IS
BEGIN
   IF (rec_.filters_ IS NULL) THEN
      rec_.filters_ := JSON_ARRAY_T();
   END IF;
   rec_.filters_.append(Build_Json___(value_));
END Add_Filters;


FUNCTION Build (
   rec_   IN PrintFilter_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN PrintFilter_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('value', rec_.value_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY PrintFilter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Value (
   rec_   IN OUT NOCOPY PrintFilter_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.value_ := value_;
END Set_Value;

FUNCTION Build (
   rec_   IN CommandGroup_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CommandGroup_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('type', rec_.type_);
   END IF;
   IF (rec_.name_ IS NOT NULL) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.commands_ IS NOT NULL) THEN
      IF (rec_.commands_ IS NULL) THEN
         json_.put('commands', JSON_ARRAY_T());
      ELSE
         json_.put('commands', rec_.commands_);
      END IF;
   END IF;
   IF (rec_.content_ IS NOT NULL) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Type (
   rec_   IN OUT NOCOPY CommandGroup_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.type_ := value_;
END Set_Type;
  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY CommandGroup_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY CommandGroup_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY CommandGroup_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Add_Commands (
   rec_   IN OUT NOCOPY CommandGroup_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   IF (rec_.commands_ IS NULL) THEN
      rec_.commands_ := JSON_ARRAY_T();
   END IF;
   rec_.commands_.append(value_);
END Add_Commands;
  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY CommandGroup_Rec,
   value_ IN            CommandGroup_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


FUNCTION Build (
   rec_   IN CommandButtonInput_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CommandButtonInput_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('visible', rec_.visible_);
   END IF;
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.disabled_ IS NOT NULL) THEN
      json_.put('disabled', rec_.disabled_);
   END IF;
   IF (rec_.background_color_ IS NOT NULL) THEN
      json_.put('backgroundColor', rec_.background_color_);
   END IF;
   IF (rec_.color_ IS NOT NULL) THEN
      json_.put('color', rec_.color_);
   END IF;
   IF (rec_.tooltip_ IS NOT NULL) THEN
      json_.put('tooltip', rec_.tooltip_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY CommandButtonInput_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY CommandButtonInput_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY CommandButtonInput_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Disabled (
   rec_   IN OUT NOCOPY CommandButtonInput_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.disabled_ := value_;
END Set_Disabled;
  
PROCEDURE Set_Background_Color (
   rec_   IN OUT NOCOPY CommandButtonInput_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.background_color_ := value_;
END Set_Background_Color;
  
PROCEDURE Set_Color (
   rec_   IN OUT NOCOPY CommandButtonInput_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.color_ := value_;
END Set_Color;
  
PROCEDURE Set_Tooltip (
   rec_   IN OUT NOCOPY CommandButtonInput_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.tooltip_ := value_;
END Set_Tooltip;
------------------------------ COMMON METADATA ------------------------------

FUNCTION Build (
   rec_   IN Emphasis_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Emphasis_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY Emphasis_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;

FUNCTION Build (
   rec_   IN Attachments_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Attachments_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.enabled_ = 'TRUE') THEN
         json_.put('enabled', TRUE);
      ELSIF (rec_.enabled_ = 'FALSE') THEN
         json_.put('enabled', FALSE);
      ELSE
         json_.put('enabled', rec_.enabled_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY Attachments_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.enabled_ := value_;
END Set_Enabled;


PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY Attachments_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.enabled_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Enabled;

FUNCTION Build (
   rec_   IN Media_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Media_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      IF (rec_.enabled_ = 'TRUE') THEN
         json_.put('enabled', TRUE);
      ELSIF (rec_.enabled_ = 'FALSE') THEN
         json_.put('enabled', FALSE);
      ELSE
         json_.put('enabled', rec_.enabled_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY Media_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.enabled_ := value_;
END Set_Enabled;


PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY Media_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.enabled_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Enabled;

FUNCTION Build (
   rec_   IN CrudActions_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CrudActions_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.hooks_ IS NOT NULL) THEN
      IF (rec_.hooks_ IS NULL) THEN
         json_.put('hooks', JSON_OBJECT_T());
      ELSE
         json_.put('hooks', rec_.hooks_);
      END IF;
   END IF;
   IF (rec_.new_ IS NOT NULL) THEN
      IF (rec_.new_ IS NULL) THEN
         json_.put('new', JSON_OBJECT_T());
      ELSE
         json_.put('new', rec_.new_);
      END IF;
   END IF;
   IF (rec_.edit_ IS NOT NULL) THEN
      IF (rec_.edit_ IS NULL) THEN
         json_.put('edit', JSON_OBJECT_T());
      ELSE
         json_.put('edit', rec_.edit_);
      END IF;
   END IF;
   IF (rec_.delete_ IS NOT NULL) THEN
      IF (rec_.delete_ IS NULL) THEN
         json_.put('delete', JSON_OBJECT_T());
      ELSE
         json_.put('delete', rec_.delete_);
      END IF;
   END IF;
   IF (rec_.defaultcopy_ IS NOT NULL) THEN
      IF (rec_.defaultcopy_ IS NULL) THEN
         json_.put('defaultcopy', JSON_OBJECT_T());
      ELSE
         json_.put('defaultcopy', rec_.defaultcopy_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Hooks (
   rec_   IN OUT NOCOPY CrudActions_Rec,
   value_ IN            CrudActionHooks_Rec )
IS
BEGIN
   rec_.hooks_ := Build_Json___(value_);
END Set_Hooks;

  

PROCEDURE Set_New (
   rec_   IN OUT NOCOPY CrudActions_Rec,
   value_ IN            CrudAction_Rec )
IS
BEGIN
   rec_.new_ := Build_Json___(value_);
END Set_New;

  

PROCEDURE Set_Edit (
   rec_   IN OUT NOCOPY CrudActions_Rec,
   value_ IN            CrudAction_Rec )
IS
BEGIN
   rec_.edit_ := Build_Json___(value_);
END Set_Edit;

  

PROCEDURE Set_Delete (
   rec_   IN OUT NOCOPY CrudActions_Rec,
   value_ IN            CrudAction_Rec )
IS
BEGIN
   rec_.delete_ := Build_Json___(value_);
END Set_Delete;

  

PROCEDURE Set_Defaultcopy (
   rec_   IN OUT NOCOPY CrudActions_Rec,
   value_ IN            CrudAction_Rec )
IS
BEGIN
   rec_.defaultcopy_ := Build_Json___(value_);
END Set_Defaultcopy;


FUNCTION Build (
   rec_   IN CrudActionHooks_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CrudActionHooks_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.before_ IS NOT NULL) THEN
      IF (rec_.before_ IS NULL) THEN
         json_.put('before', JSON_OBJECT_T());
      ELSE
         json_.put('before', rec_.before_);
      END IF;
   END IF;
   IF (rec_.after_ IS NOT NULL) THEN
      IF (rec_.after_ IS NULL) THEN
         json_.put('after', JSON_OBJECT_T());
      ELSE
         json_.put('after', rec_.after_);
      END IF;
   END IF;
   IF (rec_.create_ IS NOT NULL) THEN
      json_.put('create', rec_.create_);
   END IF;
   IF (rec_.update_ IS NOT NULL) THEN
      json_.put('update', rec_.update_);
   END IF;
   IF (rec_.projection_ IS NOT NULL) THEN
      json_.put('projection', rec_.projection_);
   END IF;
   RETURN json_;
END Build_Json___;

  

PROCEDURE Set_Before (
   rec_   IN OUT NOCOPY CrudActionHooks_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.before_ := Build_Json___(value_);
END Set_Before;

  

PROCEDURE Set_After (
   rec_   IN OUT NOCOPY CrudActionHooks_Rec,
   value_ IN            Command_Rec )
IS
BEGIN
   rec_.after_ := Build_Json___(value_);
END Set_After;

  
PROCEDURE Set_Create (
   rec_   IN OUT NOCOPY CrudActionHooks_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.create_ := value_;
END Set_Create;
  
PROCEDURE Set_Update (
   rec_   IN OUT NOCOPY CrudActionHooks_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.update_ := value_;
END Set_Update;
  
PROCEDURE Set_Projection (
   rec_   IN OUT NOCOPY CrudActionHooks_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.projection_ := value_;
END Set_Projection;

FUNCTION Build (
   rec_   IN CrudAction_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN CrudAction_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.enabled_ IS NOT NULL) THEN
      IF (rec_.enabled_ = 'TRUE') THEN
         json_.put('enabled', TRUE);
      ELSIF (rec_.enabled_ = 'FALSE') THEN
         json_.put('enabled', FALSE);
      ELSE
         json_.put('enabled', rec_.enabled_);
      END IF;
   END IF;
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY CrudAction_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.enabled_ := value_;
END Set_Enabled;


PROCEDURE Set_Enabled (
   rec_   IN OUT NOCOPY CrudAction_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.enabled_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Enabled;
  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY CrudAction_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY CrudAction_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;
-------------------------- COMMON IMPLEMENTATIONS ---------------------------
------------------------------ LAYOUT CONTENT -------------------------------

FUNCTION Build (
   rec_   IN Binding_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Binding_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.bindname_ IS NOT NULL) THEN
      json_.put('bindname', rec_.bindname_);
   END IF;
   IF (rec_.property_ IS NOT NULL) THEN
      json_.put('property', rec_.property_);
   END IF;
   IF (rec_.schedule_ IS NOT NULL) THEN
      json_.put('schedule', rec_.schedule_);
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Bindname (
   rec_   IN OUT NOCOPY Binding_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.bindname_ := value_;
END Set_Bindname;
  
PROCEDURE Set_Property (
   rec_   IN OUT NOCOPY Binding_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.property_ := value_;
END Set_Property;
  
PROCEDURE Set_Schedule (
   rec_   IN OUT NOCOPY Binding_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.schedule_ := value_;
END Set_Schedule;

FUNCTION Build (
   rec_   IN Override_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Override_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (rec_.label_ IS NOT NULL) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.collapsed_ IS NOT NULL) THEN
      IF (rec_.collapsed_ = 'TRUE') THEN
         json_.put('collapsed', TRUE);
      ELSIF (rec_.collapsed_ = 'FALSE') THEN
         json_.put('collapsed', FALSE);
      ELSE
         json_.put('collapsed', rec_.collapsed_);
      END IF;
   END IF;
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   IF (rec_.preselect_ IS NOT NULL) THEN
      IF (rec_.preselect_ = 'TRUE') THEN
         json_.put('preselect', TRUE);
      ELSIF (rec_.preselect_ = 'FALSE') THEN
         json_.put('preselect', FALSE);
      ELSE
         json_.put('preselect', rec_.preselect_);
      END IF;
   END IF;
   IF (rec_.emphasis_ IS NOT NULL) THEN
      IF (rec_.emphasis_ IS NULL) THEN
         json_.put('emphasis', JSON_ARRAY_T());
      ELSE
         json_.put('emphasis', rec_.emphasis_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Override_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Override_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Override_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.collapsed_ := value_;
END Set_Collapsed;


PROCEDURE Set_Collapsed (
   rec_   IN OUT NOCOPY Override_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.collapsed_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Collapsed;
  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Override_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Override_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;
  
PROCEDURE Set_Preselect (
   rec_   IN OUT NOCOPY Override_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.preselect_ := value_;
END Set_Preselect;


PROCEDURE Set_Preselect (
   rec_   IN OUT NOCOPY Override_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.preselect_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Preselect;
  
PROCEDURE Add_Emphasis (
   rec_   IN OUT NOCOPY Override_Rec,
   name_  IN            VARCHAR2,
   value_ IN            VARCHAR2 )
IS
   obj_ JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
   IF (rec_.emphasis_ IS NULL) THEN
      rec_.emphasis_ := JSON_ARRAY_T();
   END IF;
   obj_.put(name_, value_);
   rec_.emphasis_.append(obj_);
END Add_Emphasis;
---------------------------- ARRANGE DEFINITION -----------------------------

FUNCTION Build (
   rec_   IN Arrange_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Arrange_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'arrange');
   END IF;
   IF (TRUE) THEN
      NULL;
   END IF;
   IF (TRUE) THEN
      IF (rec_.arrange_ IS NULL) THEN
         json_.put('arrange', JSON_ARRAY_T());
      ELSE
         json_.put('arrange', rec_.arrange_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  

PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            PiechartElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            BarchartElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            StackedchartElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            LinechartElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            RadarchartElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            GanttchartElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            GanttchartItemElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            GanttchartRowElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            GanttchartItemStyleElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            GanttchartRowIconElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            GanttDependencyElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            GanttchartTimemarkerElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            GanttchartScheduleElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            GanttchartLegendElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            BoxMatrixElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            CalendarElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            CardElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            DiagramElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            FieldSetElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            FileSelectorElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            GroupElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            InlineGroupElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            ImageviewerElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            ListElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            MarkdownTextElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            PluginElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            ProcessviewerElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            StackedCalendarElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            SelectorElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            SingletonElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            SheetElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            SearchContextElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            TimelineElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            YearViewElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            Arrange_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;


PROCEDURE Add_Arrange (
   rec_   IN OUT NOCOPY Arrange_Rec,
   value_ IN            TabsElement_Rec )
IS
BEGIN
   IF (rec_.arrange_ IS NULL) THEN
      rec_.arrange_ := JSON_ARRAY_T();
   END IF;
   rec_.arrange_.append(Build_Json___(value_));
END Add_Arrange;

------------------------------ TABS DEFINITION ------------------------------

FUNCTION Build (
   rec_   IN TabsElement_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN TabsElement_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('elementType', 'tabs');
   END IF;
   IF (TRUE) THEN
      NULL;
   END IF;
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      IF (rec_.tabs_ IS NULL) THEN
         json_.put('tabs', JSON_ARRAY_T());
      ELSE
         json_.put('tabs', rec_.tabs_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Element_Type (
   rec_   IN OUT NOCOPY TabsElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.element_type_ := value_;
END Set_Element_Type;
  
PROCEDURE Set_Is_Reference (
   rec_   IN OUT NOCOPY TabsElement_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.is_reference_ := value_;
END Set_Is_Reference;
  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY TabsElement_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  

PROCEDURE Add_Tabs (
   rec_   IN OUT NOCOPY TabsElement_Rec,
   value_ IN            Tab_Rec )
IS
BEGIN
   IF (rec_.tabs_ IS NULL) THEN
      rec_.tabs_ := JSON_ARRAY_T();
   END IF;
   rec_.tabs_.append(Build_Json___(value_));
END Add_Tabs;


FUNCTION Build (
   rec_   IN Tab_Rec ) RETURN CLOB
IS
BEGIN
   RETURN Build_Json___(rec_).to_clob();
END Build;


FUNCTION Build_Json___ (
   rec_   IN Tab_Rec ) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('name', rec_.name_);
   END IF;
   IF (TRUE) THEN
      json_.put('label', rec_.label_);
   END IF;
   IF (rec_.translation_key_ IS NOT NULL) THEN
      json_.put('translationKey', rec_.translation_key_);
   END IF;
   IF (rec_.showlabel_ IS NOT NULL) THEN
      json_.put('showlabel', rec_.showlabel_);
   END IF;
   IF (rec_.visible_ IS NOT NULL) THEN
      IF (rec_.visible_ = 'TRUE') THEN
         json_.put('visible', TRUE);
      ELSIF (rec_.visible_ = 'FALSE') THEN
         json_.put('visible', FALSE);
      ELSE
         json_.put('visible', rec_.visible_);
      END IF;
   END IF;
   IF (rec_.content_ IS NOT NULL) THEN
      IF (rec_.content_ IS NULL) THEN
         json_.put('content', JSON_ARRAY_T());
      ELSE
         json_.put('content', rec_.content_);
      END IF;
   END IF;
   RETURN json_;
END Build_Json___;

  
PROCEDURE Set_Name (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.name_ := value_;
END Set_Name;
  
PROCEDURE Set_Label (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.label_ := value_;
END Set_Label;
  
PROCEDURE Set_Translation_Key (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.translation_key_ := value_;
END Set_Translation_Key;
  
PROCEDURE Set_Showlabel (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.showlabel_ := value_;
END Set_Showlabel;
  
PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            VARCHAR2 )
IS
BEGIN
   rec_.visible_ := value_;
END Set_Visible;


PROCEDURE Set_Visible (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            BOOLEAN )
IS
BEGIN
   rec_.visible_ := CASE value_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END;
END Set_Visible;
  

PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            PiechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            BarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            StackedchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            LinechartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            RadarchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            GanttchartElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            GanttchartItemElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            GanttchartRowElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            GanttchartItemStyleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            GanttchartRowIconElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            GanttDependencyElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            GanttchartTimemarkerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            GanttchartScheduleElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            GanttchartLegendElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            BoxMatrixElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            CalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            CardElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            DiagramElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            FieldElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            ProgressElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            FieldSetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            FileSelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            GroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            InlineGroupElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            ImageviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            ListElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            MarkdownTextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            PluginElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            ProcessviewerElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            StackedCalendarElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            SelectorElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            SingletonElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            SheetElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            SearchContextElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            TimelineElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            YearViewElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            Arrange_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;


PROCEDURE Add_Content (
   rec_   IN OUT NOCOPY Tab_Rec,
   value_ IN            TabsElement_Rec )
IS
BEGIN
   IF (rec_.content_ IS NULL) THEN
      rec_.content_ := JSON_ARRAY_T();
   END IF;
   rec_.content_.append(Build_Json___(value_));
END Add_Content;

