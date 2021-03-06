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

module Handler.TableDetail where

import Import

getTableDetailR :: TableId -> Handler Html
getTableDetailR tableId = do
    columns <- runDB $ selectList [ColumnTableId ==. tableId] []
    table <- runDB $ get404 tableId
    let teamId = tableTeamId table
    team <- runDB $ get404 teamId 
    uid <- requireAuthId
    mProfile <- runDB $ getBy $ UniqueProfile uid
    case mProfile of
        Nothing -> notFound
        Just (Entity profileId _) -> do
            Entity _ perm <- runDB $ getBy404 $ UniquePair profileId tableId
            defaultLayout $ do
                setTitle . toHtml $ tableName table
                $(widgetFile "table-detail")
