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



module Handler.TeamDetail where

import Import

getTeamDetailR :: TeamId -> Handler Html
getTeamDetailR teamId = do
    team <- runDB $ getJust teamId
    tables <- runDB $ selectList [TableTeamId ==. Just teamId] []
    defaultLayout $ do
        setTitle . toHtml $ "Update column " <> teamName team
        $(widgetFile "team-detail")
