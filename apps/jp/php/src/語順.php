<?php

declare(strict_types=1);

namespace アプリ;

/** 数(3) で語順再現用の包みを作る */
function 数(int $値): 数
{
    return new 数($値);
}
