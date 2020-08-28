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
module Handler.CompanyDetail where

import Import

getCompanyDetailR :: CompanyId -> Handler Html
getCompanyDetailR companyId = do
    company <- runDB $ get404 companyId
    defaultLayout $ do
        setTitle . toHtml $ companyName company <> "'s page"
        $(widgetFile "company-detail")