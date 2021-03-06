module Handler.Comment where

import Import

postCommentR :: Handler Value
postCommentR = do
    -- requireCheckJsonBody will parse the request body into the appropriate type, or return a 400 status code if the request JSON is invalid.
    -- (The ToJSON and FromJSON instances are derived in the config/models file).
    comment <- requireCheckJsonBody :: Handler Comment

    -- The YesodAuth instance in Foundation.hs defines the UserId to be the type used for authentication.
    maybeCurrentUserId <- maybeAuthId
    let comment' = comment { commentUserId = maybeCurrentUserId }
    -- use commentId <- insert comment
    -- update commentId [commentUserId =. maybeCurrentUserId]
    --mTE <- runDB $ selectFirst [TableName ==. "fake table"] []
    --let (Entity tableId _) = fromJust mTE
    --runDB $ insert $ Permission (fromJust maybeCurrentUserId) tableId View
    
    insertedComment <- runDB $ insertEntity comment'
    returnJson insertedComment
