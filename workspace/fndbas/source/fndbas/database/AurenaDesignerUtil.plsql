-----------------------------------------------------------------------------
--
--  Logical unit: AurenaDesignerUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

const_layer_published_     CONSTANT NUMBER      := 2;
const_layer_draft_         CONSTANT NUMBER      := 90;

const_visibility_draft_    CONSTANT VARCHAR2(5) := 'Draft';
const_visibility_reverted_ CONSTANT VARCHAR2(8) := 'Reverted';
const_visibility_public_   CONSTANT VARCHAR2(6) := 'Public';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Refresh_Mobile_Application___
IS
BEGIN
   $IF Component_Fndmob_SYS.INSTALLED $THEN
      Mobile_Client_SYS.Refresh_Active_List_;
   $ELSE
      NULL;
   $END
END Refresh_Mobile_Application___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Publish_Page_Configurations (
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2 ) 
IS   
   CURSOR get_pending_deletes IS      
      SELECT data_id
      FROM   FND_MODEL_DESIGN_DATA_TAB t
      WHERE  model_id = model_id_
      AND    scope_id = scope_id_
      AND    layer_no = const_layer_draft_
      AND    visibility = const_visibility_reverted_;
   
   CURSOR get_drafts IS      
      SELECT data_id, content, based_on_content
      FROM   FND_MODEL_DESIGN_DATA_TAB
      WHERE  model_id = model_id_
      AND    scope_id = scope_id_
      AND    layer_no = const_layer_draft_
      AND    visibility = const_visibility_draft_;
BEGIN
   FOR next_ IN get_pending_deletes LOOP
      -- Removed Deleted published artifacts
      Model_Design_SYS.Delete_Config_Content(model_id_, scope_id_, next_.data_id, const_layer_published_);
      -- Removed Revereted Drafts
      Model_Design_SYS.Delete_Config_Content(model_id_, scope_id_, next_.data_id, const_layer_draft_);
   END LOOP;
   
   FOR next_ IN get_drafts LOOP
      Model_Design_SYS.Save_Config_Content(model_id_, scope_id_, next_.data_id, next_.content, based_on_content_ => next_.based_on_content, layer_no_=> const_layer_published_, visibility_=> const_visibility_public_);
      Model_Design_SYS.Toggle_Visibility(model_id_, scope_id_, next_.data_id, const_layer_draft_, const_visibility_public_);
   END LOOP;
   
   Model_Design_SYS.Use_Profiled_Data(model_id_);   
   -- Notifying mobile framwork to clear its metadata cache
   Refresh_Mobile_Application___;   
END Publish_Page_Configurations;


PROCEDURE Publish_Page_Configurations (
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2,
   data_id_  IN VARCHAR2) 
IS   
   draft_ fnd_model_design_data_tab%ROWTYPE;
   
BEGIN
   IF Model_Design_Util_API.Try_Get_Draft_Data_Row_(model_id_, scope_id_, data_id_, draft_) THEN
      IF(draft_.visibility = const_visibility_reverted_) THEN
         -- Removed Deleted published artifacts
         Model_Design_SYS.Delete_Config_Content(model_id_, scope_id_, data_id_, const_layer_published_);
         -- Removed Revereted Drafts
         Model_Design_SYS.Delete_Config_Content(model_id_, scope_id_, data_id_, const_layer_draft_);
      ELSIF (draft_.visibility = const_visibility_draft_) THEN   
         Model_Design_SYS.Save_Config_Content(model_id_, scope_id_, data_id_, draft_.content, draft_.based_on_content, '', const_layer_published_, const_visibility_public_);
         -- Update visibility of draft
         Model_Design_SYS.Toggle_Visibility(model_id_, scope_id_, data_id_, const_layer_draft_, const_visibility_public_);
      END IF;

      Model_Design_SYS.Use_Profiled_Data(model_id_);   
      -- Notifying mobile framwork to clear its metadata cache
      Refresh_Mobile_Application___;  

   ELSE
         Error_SYS.Record_General(lu_name_, 'PUBLISH_NON_DRAFT: Only draft records can be published.');
   END IF;
END Publish_Page_Configurations;


PROCEDURE Unpublish_Page_Configurations (
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2 )
IS
   CURSOR get_pending_deletes IS      
      SELECT data_id
      FROM   FND_MODEL_DESIGN_DATA_TAB
      WHERE  model_id = model_id_
      AND    scope_id = scope_id_
      AND    layer_no = const_layer_draft_
      AND    visibility = const_visibility_reverted_;
   
   CURSOR get_published IS      
      SELECT data_id
      FROM   FND_MODEL_DESIGN_DATA_TAB
      WHERE  model_id = model_id_
      AND    scope_id = scope_id_
      AND    layer_no = const_layer_published_;          
BEGIN
   -- Remove Revereted Drafts
   FOR next_ IN get_pending_deletes LOOP
      Model_Design_SYS.Delete_Config_Content(model_id_, scope_id_, next_.data_id, const_layer_draft_);
   END LOOP;
   
   FOR next_ IN get_published LOOP
      BEGIN
         Model_Design_SYS.Toggle_Visibility(model_id_, scope_id_, next_.data_id, const_layer_draft_, const_visibility_draft_);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            NULL; -- Draft object do not exist for some reason
         WHEN OTHERS THEN
            RAISE;
      END;
      Model_Design_SYS.Delete_Config_Content(model_id_, scope_id_, next_.data_id, const_layer_published_);
   END LOOP;
   
   -- Notifying mobile framwork to clear its metadata cache
   Refresh_Mobile_Application___;   
END Unpublish_Page_Configurations;


PROCEDURE Unpublish_Page_Configurations (
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2,
   data_id_  IN VARCHAR2)
IS
   published_ fnd_model_design_data_tab%ROWTYPE;
   draft_ fnd_model_design_data_tab%ROWTYPE;
   
BEGIN
   
   IF Model_Design_Util_API.Try_Get_Published_Data_Row_(model_id_, scope_id_, data_id_, published_) THEN
      -- Delete published
      Model_Design_SYS.Delete_Config_Content(model_id_, scope_id_, data_id_, const_layer_published_);
   END IF;
   
   IF Model_Design_Util_API.Try_Get_Draft_Data_Row_(model_id_, scope_id_, data_id_, draft_) THEN
      IF(draft_.visibility = const_visibility_reverted_) THEN
         -- Removed Revereted drafts
         Model_Design_SYS.Delete_Config_Content(model_id_, scope_id_, data_id_, const_layer_draft_);
      ELSE
         -- Change visibility of the draft
         Model_Design_SYS.Toggle_Visibility(model_id_, scope_id_, data_id_, const_layer_draft_, const_visibility_draft_);
      END IF;
   END IF;
   
   -- Notifying mobile framwork to clear its metadata cache
   Refresh_Mobile_Application___;   
END Unpublish_Page_Configurations;


-- Delete is carried out on drafts
PROCEDURE Delete_Page_Configurations (
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2,
   data_id_  IN VARCHAR2) 
IS
   published_ fnd_model_design_data_tab%ROWTYPE;
   draft_ fnd_model_design_data_tab%ROWTYPE;
   published_found_ BOOLEAN;
   draft_found_ BOOLEAN;
   
BEGIN
   draft_found_ := Model_Design_Util_API.Try_Get_Draft_Data_Row_(model_id_, scope_id_, data_id_, draft_);
   published_found_ := Model_Design_Util_API.Try_Get_Published_Data_Row_(model_id_, scope_id_, data_id_, published_);
   
   IF published_found_ AND draft_found_ AND published_.content_hash = draft_.content_hash THEN
      -- published should be unpublished first
      Error_SYS.Record_General(lu_name_, 'DELETE_PUBLISHED: Published record must be unpublished before deletion.');
      RETURN;
   END IF;
   
   IF published_found_ AND draft_found_ AND published_.content_hash <> draft_.content_hash THEN
      -- Published layer is present but draft have unpublished changes
      -- Re create the draft based on the published layer content. Visibility should be public as this version of the draft is already published.
      Model_Design_SYS.Save_Config_Content(model_id_, scope_id_, data_id_, published_.content, published_.based_on_content, '', const_layer_draft_ , const_visibility_public_, published_.schema_version); 
   ELSIF draft_found_ THEN
      -- If only draft layer present, delete the draft
      Model_Design_SYS.Delete_Config_Content(model_id_, scope_id_, data_id_, const_layer_draft_);
   END IF;
   
   -- Notifying mobile framwork to clear its metadata cache
   Refresh_Mobile_Application___;   
END Delete_Page_Configurations;



-------------------- LU  NEW METHODS -------------------------------------
