use Sway::API::Criteria;

unit role Sway::API::Command::Criteria;

method criteria(
            :$all            , :$app-id         , :$class               , :$con-id   ,
            :$con-mark       , :$floating       , :$id                  , :$instance ,
            :$pid            , :$shell          , :$tiling              , :$title    ,
            :$urgen          , :$window-role    , :$window-type         , :$workspace,
            :$sandbox-engine , :$sandboc-app-id , :$sandbox-instance-id , *%_ where !*.elems
) {
    Sway::API::Criteria.new: :client(self), :criteria{
            :$all            , :$app-id         , :$class               , :$con-id   ,
            :$con-mark       , :$floating       , :$id                  , :$instance ,
            :$pid            , :$shell          , :$tiling              , :$title    ,
            :$urgen          , :$window-role    , :$window-type         , :$workspace,
            :$sandbox-engine , :$sandboc-app-id , :$sandbox-instance-id
    }
}

