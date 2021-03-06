{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.TablePermissions where

import Import

data PermissionData = PermissionData 
    { permissionDataProfileId :: ProfileId
    , permissionDataType :: PermissionType
    }

profileAttributes :: FieldSettings master
profileAttributes = FieldSettings 
    "Select a user" -- The label
    Nothing -- The tooltip
    Nothing -- The Id
    Nothing -- The name attr
    [("class", "")] -- list of attributes and their values

permissionAttributes :: FieldSettings master
permissionAttributes = FieldSettings 
    "Select a Permission type" -- The label
    Nothing -- The tooltip
    Nothing -- The Id
    Nothing -- The name attr
    [("class", "")] -- list of attributes and their values


validProfiles :: Handler [Filter Profile]
validProfiles = do
    uid <- requireAuthId
    mProfile <- runDB $ getBy $ UniqueProfile uid
    team <- case mProfile of
        Nothing -> notFound
        Just (Entity _ profile) -> runDB $ get404 $ profileTeamId profile
    teams <- runDB $ selectList [TeamCompanyId ==. teamCompanyId team] []
    pure $ map ((ProfileTeamId ==.) . entityKey) teams

permissionForm :: Form PermissionData
permissionForm = renderDivs $ PermissionData
    <$> areq (selectField uTuples) profileAttributes Nothing
    <*> areq (selectFieldList pTuples) permissionAttributes Nothing
      where
          pTuples = [("Own" :: Text, Own), ("Edit", Edit), ("View", View)]
          uTuples = do
              profiles <- validProfiles
              optionsPersistKey profiles [] profileName

getTablePermissionsR :: TableId -> Handler Html
getTablePermissionsR tableId = do
    table <- runDB $ get404 tableId
    (widget, enctype) <- generateFormPost permissionForm
    defaultLayout $ do
        setTitle . toHtml $ "Add permissions for table: " <> tableName table
        $(widgetFile "table-permissions")

postTablePermissionsR :: TableId -> Handler ()
postTablePermissionsR tableId = do
    ((result, _), _) <- runFormPost permissionForm
    case result of
        FormSuccess permissionData -> do
            let profileId = permissionDataProfileId permissionData
            _ <- runDB $ insert $ Permission
                profileId
                tableId
                (permissionDataType permissionData)
            redirect $ TableR tableId TableDetailR
        _ -> redirect $ TableR tableId TablePermissionsR
