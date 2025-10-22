<?php
require_once 'function.php';
require_once 'config.php';
require_once 'botapi.php';
global $connect;
//-----------------------------------------------------------------
try {
    $tableName = 'user';
    // Check if table exists
    $stmt = $pdo->prepare("SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = :tableName");
    $stmt->bindParam(':tableName', $tableName);
    $stmt->execute();
    $tableExists = $stmt->fetch(PDO::FETCH_ASSOC) !== false;

    if (!$tableExists) {
        $stmt = $pdo->prepare("CREATE TABLE `$tableName` (
            id VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            limit_usertest INT NOT NULL DEFAULT 0,
            roll_Status TINYINT(1) NOT NULL DEFAULT 0,
            username VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            Processing_value TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            Processing_value_one TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            Processing_value_tow TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            Processing_value_four TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            step VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            description_blocking TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            number VARCHAR(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            Balance INT NOT NULL DEFAULT 0,
            User_Status VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            pagenumber INT NOT NULL DEFAULT 0,
            message_count VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            last_message_time VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            agent VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            affiliatescount VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            affiliates VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            namecustom VARCHAR(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            number_username VARCHAR(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            register VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            verify VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            cardpayment VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            codeInvitation VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            pricediscount VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
            maxbuyagent VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
            joinchannel VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
            checkstatus VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
            bottype TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            score INT NOT NULL DEFAULT 0,
            limitchangeloc VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
            status_cron VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '1',
            expire VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            token VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            PRIMARY KEY (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
        $stmt->execute();

        // Optional: Insert initial data (uncomment if needed)
        /*
        $stmt = $pdo->prepare("INSERT INTO `$tableName` (
            id, limit_usertest, roll_Status, username, Processing_value, Processing_value_one, 
            Processing_value_tow, Processing_value_four, step, description_blocking, number, 
            Balance, User_Status, pagenumber, message_count, last_message_time, agent, 
            affiliatescount, affiliates, namecustom, number_username, register, verify, 
            cardpayment, codeInvitation, pricediscount, maxbuyagent, joinchannel, checkstatus, 
            bottype, score, limitchangeloc, status_cron, expire, token
        ) VALUES (
            :id, :limit_usertest, :roll_Status, :username, :Processing_value, :Processing_value_one, 
            :Processing_value_tow, :Processing_value_four, :step, :description_blocking, :number, 
            :Balance, :User_Status, :pagenumber, :message_count, :last_message_time, :agent, 
            :affiliatescount, :affiliates, :namecustom, :number_username, :register, :verify, 
            :cardpayment, :codeInvitation, :pricediscount, :maxbuyagent, :joinchannel, :checkstatus, 
            :bottype, :score, :limitchangeloc, :status_cron, :expire, :token
        )");
        $stmt->execute([
            ':id' => '0123456789',
            ':limit_usertest' => 0,
            ':roll_Status' => 0,
            ':username' => 'test',
            ':Processing_value' => 'none',
            ':Processing_value_one' => '',
            ':Processing_value_tow' => '',
            ':Processing_value_four' => '',
            ':step' => 'none',
            ':description_blocking' => null,
            ':number' => 'none',
            ':Balance' => 0,
            ':User_Status' => 'active',
            ':pagenumber' => 0,
            ':message_count' => '0',
            ':last_message_time' => '0',
            ':agent' => 'none',
            ':affiliatescount' => '0',
            ':affiliates' => '0',
            ':namecustom' => 'none',
            ':number_username' => '100',
            ':register' => 'none',
            ':verify' => '1',
            ':cardpayment' => '1',
            ':codeInvitation' => null,
            ':pricediscount' => '0',
            ':maxbuyagent' => '0',
            ':joinchannel' => '0',
            ':checkstatus' => '0',
            ':bottype' => null,
            ':score' => 0,
            ':limitchangeloc' => '0',
            ':status_cron' => '1',
            ':expire' => null,
            ':token' => null
        ]);
        */
        echo "Table $tableName created successfully.\n";
    } else {
        // Add missing columns with proper types
        addFieldToTable($tableName, 'id', null, 'VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'limit_usertest', '0', 'INT');
        addFieldToTable($tableName, 'roll_Status', '0', 'TINYINT(1)');
        addFieldToTable($tableName, 'username', 'none', 'VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'Processing_value', 'none', 'TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'Processing_value_one', '', 'TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'Processing_value_tow', '', 'TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'Processing_value_four', '', 'TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'step', 'none', 'VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'description_blocking', null, 'TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'number', 'none', 'VARCHAR(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'Balance', '0', 'INT');
        addFieldToTable($tableName, 'User_Status', 'active', 'VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'pagenumber', '0', 'INT');
        addFieldToTable($tableName, 'message_count', '0', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'last_message_time', '0', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'agent', 'none', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'affiliatescount', '0', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'affiliates', '0', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'namecustom', 'none', 'VARCHAR(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'number_username', '100', 'VARCHAR(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'register', 'none', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'verify', '1', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'cardpayment', '1', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'codeInvitation', null, 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'pricediscount', '0', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'maxbuyagent', '0', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'joinchannel', '0', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'checkstatus', '0', 'VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'bottype', null, 'TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'score', '0', 'INT');
        addFieldToTable($tableName, 'limitchangeloc', '0', 'VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'status_cron', '1', 'VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'expire', null, 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'token', null, 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        echo "Table $tableName already exists, checked and updated columns.\n";
    }
} catch (PDOException $e) {
    $errorMessage = "Error creating table $tableName: " . $e->getMessage();
    file_put_contents('error_log_user', $errorMessage . "\n", FILE_APPEND);
    echo $errorMessage . "\n";
}



try {
    $tableName = 'setting';
    // Check if table exists
    $stmt = $pdo->prepare("SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = :tableName");
    $stmt->bindParam(':tableName', $tableName);
    $stmt->execute();
    $tableExists = $stmt->fetch(PDO::FETCH_ASSOC) !== false;

    // Define JSON data
    $DATAAWARD = json_encode(['one' => '0', 'tow' => '0', 'theree' => '0']);
    $limitlist = json_encode(['free' => 100, 'all' => 100]);
    $status_cron = json_encode([
        'day' => true,
        'volume' => true,
        'remove' => false,
        'remove_volume' => false,
        'test' => false,
        'on_hold' => false,
        'uptime_node' => false,
        'uptime_panel' => false,
    ]);
    $keyboardmain = '{"keyboard":[[{"text":"text_sell"},{"text":"text_extend"}],[{"text":"text_usertest"},{"text":"text_wheel_luck"}],[{"text":"text_Purchased_services"},{"text":"accountwallet"}],[{"text":"text_affiliates"},{"text":"text_Tariff_list"}],[{"text":"text_support"},{"text":"text_help"}]]}';

    if (!$tableExists) {
        $stmt = $pdo->prepare("CREATE TABLE `$tableName` (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            Bot_Status VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            roll_Status VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            get_number VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            iran_number VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            NotUser VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            Channel_Report VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            limit_usertest_all VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            affiliatesstatus VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            affiliatespercentage VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            removedayc VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            showcard VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            numbercount VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            statusnewuser VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            statusagentrequest VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            statuscategory VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            statusterffh VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            volumewarn VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            inlinebtnmain VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            verifystart VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            id_support VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            statusnamecustom VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            statuscategorygenral VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            statussupportpv VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            agentreqprice VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            bulkbuy VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            on_hold_day VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            cronvolumere VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            verifybucodeuser VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            scorestatus VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            Lottery_prize TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            wheel_luck VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            wheel_luck_price VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            btn_status_extned VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            daywarn VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            categoryhelp VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            linkappstatus VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            iplogin VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            wheelagent VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            Lotteryagent VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            languageen VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            languageru VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            statusfirstwheel VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            statuslimitchangeloc VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            Debtsettlement VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            Dice VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            keyboardmain TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            statusnoteforf VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            statuscopycart VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            timeauto_not_verify VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            status_keyboard_config VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            cron_status TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            limitnumber VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
            PRIMARY KEY (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
        $stmt->execute();

        $stmt = $pdo->prepare("INSERT INTO `$tableName` (
            Bot_Status, roll_Status, get_number, iran_number, NotUser, Channel_Report, limit_usertest_all, 
            affiliatesstatus, affiliatespercentage, removedayc, showcard, numbercount, statusnewuser, 
            statusagentrequest, statuscategory, statusterffh, volumewarn, inlinebtnmain, verifystart, 
            id_support, statusnamecustom, statuscategorygenral, statussupportpv, agentreqprice, bulkbuy, 
            on_hold_day, cronvolumere, verifybucodeuser, scorestatus, Lottery_prize, wheel_luck, 
            wheel_luck_price, btn_status_extned, daywarn, categoryhelp, linkappstatus, iplogin, 
            wheelagent, Lotteryagent, languageen, languageru, statusfirstwheel, statuslimitchangeloc, 
            Debtsettlement, Dice, keyboardmain, statusnoteforf, statuscopycart, timeauto_not_verify, 
            status_keyboard_config, cron_status, limitnumber
        ) VALUES (
            :Bot_Status, :roll_Status, :get_number, :iran_number, :NotUser, :Channel_Report, :limit_usertest_all, 
            :affiliatesstatus, :affiliatespercentage, :removedayc, :showcard, :numbercount, :statusnewuser, 
            :statusagentrequest, :statuscategory, :statusterffh, :volumewarn, :inlinebtnmain, :verifystart, 
            :id_support, :statusnamecustom, :statuscategorygenral, :statussupportpv, :agentreqprice, :bulkbuy, 
            :on_hold_day, :cronvolumere, :verifybucodeuser, :scorestatus, :Lottery_prize, :wheel_luck, 
            :wheel_luck_price, :btn_status_extned, :daywarn, :categoryhelp, :linkappstatus, :iplogin, 
            :wheelagent, :Lotteryagent, :languageen, :languageru, :statusfirstwheel, :statuslimitchangeloc, 
            :Debtsettlement, :Dice, :keyboardmain, :statusnoteforf, :statuscopycart, :timeauto_not_verify, 
            :status_keyboard_config, :cron_status, :limitnumber
        )");
        $stmt->execute([
            ':Bot_Status' => 'botstatuson',
            ':roll_Status' => 'rolleon',
            ':get_number' => 'offAuthenticationphone',
            ':iran_number' => 'offAuthenticationiran',
            ':NotUser' => 'offnotuser',
            ':Channel_Report' => null,
            ':limit_usertest_all' => '1',
            ':affiliatesstatus' => 'offaffiliates',
            ':affiliatespercentage' => '0',
            ':removedayc' => '0',
            ':showcard' => '1',
            ':numbercount' => '0',
            ':statusnewuser' => 'onnewuser',
            ':statusagentrequest' => 'onrequestagent',
            ':statuscategory' => 'offcategory',
            ':statusterffh' => null,
            ':volumewarn' => '2',
            ':inlinebtnmain' => 'offinline',
            ':verifystart' => 'offverify',
            ':id_support' => '0',
            ':statusnamecustom' => 'offnamecustom',
            ':statuscategorygenral' => 'offcategorys',
            ':statussupportpv' => 'offpvsupport',
            ':agentreqprice' => '0',
            ':bulkbuy' => 'onbulk',
            ':on_hold_day' => '4',
            ':cronvolumere' => '5',
            ':verifybucodeuser' => 'offverify',
            ':scorestatus' => '0',
            ':Lottery_prize' => $DATAAWARD,
            ':wheel_luck' => '0',
            ':wheel_luck_price' => '0',
            ':btn_status_extned' => null,
            ':daywarn' => '2',
            ':categoryhelp' => '0',
            ':linkappstatus' => '0',
            ':iplogin' => '0',
            ':wheelagent' => '1',
            ':Lotteryagent' => '1',
            ':languageen' => '0',
            ':languageru' => '0',
            ':statusfirstwheel' => '0',
            ':statuslimitchangeloc' => '0',
            ':Debtsettlement' => '1',
            ':Dice' => '0',
            ':keyboardmain' => $keyboardmain,
            ':statusnoteforf' => '1',
            ':statuscopycart' => '0',
            ':timeauto_not_verify' => '4',
            ':status_keyboard_config' => '1',
            ':cron_status' => $status_cron,
            ':limitnumber' => $limitlist
        ]);
        echo "Table $tableName created and data inserted successfully.\n";
    } else {
        // Add missing columns
        addFieldToTable($tableName, 'Bot_Status', 'botstatuson', 'VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'roll_Status', 'rolleon', 'VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'get_number', 'offAuthenticationphone', 'VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'iran_number', 'offAuthenticationiran', 'VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'NotUser', 'offnotuser', 'VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'Channel_Report', null, 'VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'limit_usertest_all', '1', 'VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'affiliatesstatus', 'offaffiliates', 'VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'affiliatespercentage', '0', 'VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'removedayc', '0', 'VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'showcard', '1', 'VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'numbercount', '0', 'VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'statusnewuser', 'onnewuser', 'VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'statusagentrequest', 'onrequestagent', 'VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'statuscategory', 'offcategory', 'VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'statusterffh', null, 'VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'volumewarn', '2', 'VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'inlinebtnmain', 'offinline', 'VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'verifystart', 'offverify', 'VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'id_support', '0', 'VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'statusnamecustom', 'offnamecustom', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'statuscategorygenral', 'offcategorys', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'statussupportpv', 'offpvsupport', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'agentreqprice', '0', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'bulkbuy', 'onbulk', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'on_hold_day', '4', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'cronvolumere', '5', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'verifybucodeuser', 'offverify', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'scorestatus', '0', 'VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'Lottery_prize', $DATAAWARD, 'TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'wheel_luck', '0', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'wheel_luck_price', '0', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'btn_status_extned', null, 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'daywarn', '2', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'categoryhelp', '0', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'linkappstatus', '0', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'iplogin', '0', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'wheelagent', '1', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'Lotteryagent', '1', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'languageen', '0', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'languageru', '0', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'statusfirstwheel', '0', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'statuslimitchangeloc', '0', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'Debtsettlement', '1', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'Dice', '0', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'keyboardmain', $keyboardmain, 'TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'statusnoteforf', '1', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'statuscopycart', '0', 'VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'timeauto_not_verify', '4', 'VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'status_keyboard_config', '1', 'VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'cron_status', $status_cron, 'TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        addFieldToTable($tableName, 'limitnumber', $limitlist, 'VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        echo "Table $tableName already exists, checked and updated columns.\n";
    }
} catch (Exception $e) {
    $errorMessage = "Error creating table $tableName: " . $e->getMessage();
    file_put_contents('error_log_setting', $errorMessage, FILE_APPEND);
    echo $errorMessage . "\n";
}

//-----------------------------------------------------------------
try {

    $tableName = 'help';
    $stmt = $pdo->prepare("SELECT 1 FROM information_schema.tables WHERE table_name = :tableName");
    $stmt->bindParam(':tableName', $tableName);
    $stmt->execute();
    $tableExists = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$tableExists) {
        $stmt = $pdo->prepare("CREATE TABLE $tableName (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        name_os varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Media_os varchar(5000) NOT NULL,
        type_Media_os varchar(500) NOT NULL,
        category TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Description_os TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        $stmt->execute();
    } else {
        addFieldToTable("help", "category", null, "TEXT");
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
//-----------------------------------------------------------------


//-----------------------------------------------------------------
try {
    $tableName = 'admin';
    $stmt = $pdo->prepare("SELECT 1 FROM information_schema.tables WHERE table_name = :tableName");
    $stmt->bindParam(':tableName', $tableName);
    $stmt->execute();
    $tableExists = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$tableExists) {
        $stmt = $pdo->prepare("CREATE TABLE $tableName (
        id_admin varchar(500) PRIMARY KEY NOT NULL,
        username varchar(1000) NOT NULL,
        password varchar(1000) NOT NULL,
        rule varchar(500) NOT NULL)");
        $stmt->execute();
        $randomString = bin2hex(random_bytes(5));
        $stmt = $pdo->prepare("INSERT INTO admin (id_admin,rule,username,password) VALUES ('$adminnumber','administrator','admin','$randomString')");
        $stmt->execute();
    } else {
        addFieldToTable("admin", "rule", "administrator", "VARCHAR(200)");
        addFieldToTable("admin", "username", null, "VARCHAR(200)");
        addFieldToTable("admin", "password", null, "VARCHAR(200)");
    }
} catch (Exception $e) {
    file_put_contents('error_log admin', $e->getMessage());
}
//-----------------------------------------------------------------
try {
    $tableName = 'channels';
    $stmt = $pdo->prepare("SELECT 1 FROM information_schema.tables WHERE table_name = :tableName");
    $stmt->bindParam(':tableName', $tableName);
    $stmt->execute();
    $tableExists = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$tableExists) {
        $stmt = $pdo->prepare("CREATE TABLE $tableName (
            remark varchar(200) NOT NULL,
            linkjoin varchar(200) NOT NULL,
            link varchar(200) NOT NULL)");
        $stmt->execute();
    } else {
        addFieldToTable("channels", "remark", null, "VARCHAR(200)");
        addFieldToTable("channels", "linkjoin", null, "VARCHAR(200)");
    }
} catch (Exception $e) {
    file_put_contents('error_log channels', $e->getMessage());
}
//--------------------------------------------------------------
try {

    $result = $connect->query("SHOW TABLES LIKE 'marzban_panel'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE marzban_panel (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        code_panel varchar(200) NULL,
        name_panel varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        status varchar(500) NULL,
        url_panel varchar(2000) NULL,
        username_panel varchar(200) NULL,
        password_panel varchar(200) NULL,
        agent varchar(200) NULL,
        sublink varchar(500) NULL,
        config varchar(500) NULL,
        MethodUsername varchar(700) NULL,
        TestAccount varchar(100) NULL,
        limit_panel varchar(100) NULL,
        namecustom varchar(100) NULL,
        Methodextend varchar(100) NULL,
        conecton varchar(100) NULL,
        linksubx varchar(1000) NULL,
        inboundid varchar(100) NULL,
        type varchar(100) NULL,
        inboundstatus varchar(100) NULL,
        hosts  JSON  NULL,
        inbound_deactive varchar(100) NULL,
        time_usertest varchar(100) NULL,
        val_usertest varchar(100)  NULL,
        secret_code varchar(200) NULL,
        priceChangeloc varchar(200) NULL,
        priceextravolume varchar(500) NULL,
        pricecustomvolume varchar(500) NULL,
        pricecustomtime varchar(500) NULL,
        priceextratime varchar(500) NULL,
        mainvolume varchar(500) NULL,
        maxvolume varchar(500) NULL,
        maintime varchar(500) NULL,
        maxtime varchar(500) NULL,
        status_extend varchar(100) NULL,
        datelogin TEXT NULL,
        proxies TEXT NULL,
        inbounds TEXT NULL,
        subvip varchar(60) NULL,
        changeloc varchar(60) NULL,
        on_hold_test varchar(60) NOT NULL,
        customvolume TEXT NULL,
        hide_user TEXT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table marzban_panel" . mysqli_error($connect);
        }
    } else {
        $VALUE = json_encode(array(
            'f' => '0',
            'n' => '0',
            'n2' => '0'
        ));
        $valueprice = json_encode(array(
            'f' => "4000",
            'n' => "4000",
            'n2' => "4000"
        ));
        $valuemain = json_encode(array(
            'f' => "1",
            'n' => "1",
            'n2' => "1"
        ));
        $valuemax = json_encode(array(
            'f' => "1000",
            'n' => "1000",
            'n2' => "1000"
        ));
        $valuemax_time = json_encode(array(
            'f' => "365",
            'n' => "365",
            'n2' => "365"
        ));
        addFieldToTable("marzban_panel", "on_hold_test", "1", "VARCHAR(60)");
        addFieldToTable("marzban_panel", "proxies", null, "TEXT");
        addFieldToTable("marzban_panel", "inbounds", null, "TEXT");
        addFieldToTable("marzban_panel", "customvolume", $VALUE, "TEXT");
        addFieldToTable("marzban_panel", "subvip", "offsubvip", "VARCHAR(60)");
        addFieldToTable("marzban_panel", "changeloc", "offchangeloc", "VARCHAR(60)");
        addFieldToTable("marzban_panel", "hide_user", null, "TEXT");
        addFieldToTable("marzban_panel", "status_extend", "on_extend", "VARCHAR(50)");
        addFieldToTable("marzban_panel", "code_panel", null, "VARCHAR(50)");
        addFieldToTable("marzban_panel", "priceextravolume", $valueprice, "VARCHAR(500)");
        addFieldToTable("marzban_panel", "pricecustomvolume", $valueprice, "VARCHAR(500)");
        addFieldToTable("marzban_panel", "pricecustomtime", $valueprice, "VARCHAR(500)");
        addFieldToTable("marzban_panel", "priceextratime", $valueprice, "VARCHAR(500)");
        addFieldToTable("marzban_panel", "priceChangeloc", "0", "VARCHAR(100)");
        addFieldToTable("marzban_panel", "mainvolume", $valuemain, "VARCHAR(500)");
        addFieldToTable("marzban_panel", "maxvolume", $valuemax, "VARCHAR(500)");
        addFieldToTable("marzban_panel", "maintime", $valuemain, "VARCHAR(500)");
        addFieldToTable("marzban_panel", "maxtime", $valuemax_time, "VARCHAR(500)");
        addFieldToTable("marzban_panel", "MethodUsername", "آیدی عددی + حروف و عدد رندوم", "VARCHAR(100)");
        addFieldToTable("marzban_panel", "datelogin", null, "TEXT");
        addFieldToTable("marzban_panel", "val_usertest", "100", "VARCHAR(50)");
        addFieldToTable("marzban_panel", "time_usertest", "1", "VARCHAR(50)");
        addFieldToTable("marzban_panel", "secret_code", null, "VARCHAR(200)");
        addFieldToTable("marzban_panel", "inboundstatus", "offinbounddisable", "VARCHAR(50)");
        addFieldToTable("marzban_panel", "inbound_deactive", "0", "VARCHAR(100)");
        addFieldToTable("marzban_panel", "agent", "all", "VARCHAR(50)");
        addFieldToTable("marzban_panel", "inboundid", "1", "VARCHAR(50)");
        addFieldToTable("marzban_panel", "linksubx", null, "VARCHAR(200)");
        addFieldToTable("marzban_panel", "conecton", "offconecton", "VARCHAR(100)");
        addFieldToTable("marzban_panel", "type", "marzban", "VARCHAR(50)");
        addFieldToTable("marzban_panel", "Methodextend", "ریست حجم و زمان", "VARCHAR(100)");
        addFieldToTable("marzban_panel", "namecustom", "vpn", "VARCHAR(100)");
        addFieldToTable("marzban_panel", "limit_panel", "unlimted", "VARCHAR(50)");
        addFieldToTable("marzban_panel", "TestAccount", "ONTestAccount", "VARCHAR(50)");
        addFieldToTable("marzban_panel", "status", "active", "VARCHAR(50)");
        addFieldToTable("marzban_panel", "sublink", "onsublink", "VARCHAR(50)");
        addFieldToTable("marzban_panel", "config", "offconfig", "VARCHAR(50)");
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
//-----------------------------------------------------------------
try {

    $result = $connect->query("SHOW TABLES LIKE 'product'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE product (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        code_product varchar(200)  NULL,
        name_product varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        price_product varchar(2000) NULL,
        Volume_constraint varchar(2000) NULL,
        Location varchar(200) NULL,
        Service_time varchar(200) NULL,
        agent varchar(100) NULL,
        note TEXT NULL,
        data_limit_reset varchar(200) NULL,
        one_buy_status varchar(20) NOT NULL,
        inbounds TEXT NULL,
        proxies TEXT NULL,
        category varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        hide_panel TEXT  NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table product" . mysqli_error($connect);
        }
    } else {
        addFieldToTable("product", "one_buy_status", "0", "VARCHAR(20)");
        addFieldToTable("product", "Location", null, "VARCHAR(200)");
        addFieldToTable("product", "inbounds", null, "TEXT");
        addFieldToTable("product", "proxies", null, "TEXT");
        addFieldToTable("product", "category", null, "varchar(200)");
        addFieldToTable("product", "note", '', "TEXT");
        addFieldToTable("product", "hide_panel", '{}', "TEXT");
        addFieldToTable("product", "data_limit_reset", "no_reset", "varchar(100)");
        addFieldToTable("product", "agent", "f", "varchar(50)");
        addFieldToTable("product", "code_product", null, "varchar(50)");
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
//-----------------------------------------------------------------
try {

    $result = $connect->query("SHOW TABLES LIKE 'invoice'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE invoice (
        id_invoice varchar(200) PRIMARY KEY,
        id_user varchar(200) NULL,
        username varchar(300) NULL,
        Service_location varchar(300) NULL,
        time_sell VARCHAR(200) NULL,
        name_product varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
        price_product varchar(200) NULL,
        Volume varchar(200) NULL,
        Service_time varchar(200) NULL,
        uuid TEXT NULL,
        note varchar(500) NULL,
        user_info TEXT NULL,
        bottype varchar(200) NULL,
        refral varchar(100) NULL,
        time_cron varchar(100) NULL,
        notifctions TEXT NOT NULL,
        Status varchar(200) NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table invoice" . mysqli_error($connect);
        }
    } else {
        $Check_filde = $connect->query("SHOW COLUMNS FROM invoice LIKE 'note'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $result = $connect->query("ALTER TABLE invoice ADD note VARCHAR(700)");
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM invoice LIKE 'notifctions'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $data = json_encode(array(
                'volume' => false,
                'time' => false,
            ));
            $result = $connect->query("ALTER TABLE invoice ADD notifctions TEXT NOT NULL");
            $connect->query("UPDATE invoice SET notifctions = '$data'");
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM invoice LIKE 'time_cron'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $result = $connect->query("ALTER TABLE invoice ADD time_cron VARCHAR(100)");
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM invoice LIKE 'refral'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $result = $connect->query("ALTER TABLE invoice ADD refral VARCHAR(100)");
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM invoice LIKE 'bottype'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $result = $connect->query("ALTER TABLE invoice ADD bottype VARCHAR(200)");
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM invoice LIKE 'user_info'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $result = $connect->query("ALTER TABLE invoice ADD user_info TEXT");
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM invoice LIKE 'time_sell'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $result = $connect->query("ALTER TABLE invoice ADD time_sell VARCHAR(200)");
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM invoice LIKE 'uuid'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $result = $connect->query("ALTER TABLE invoice ADD uuid TEXT");
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM invoice LIKE 'Status'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $result = $connect->query("ALTER TABLE invoice ADD Status VARCHAR(100)");
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
//-----------------------------------------------------------------
try {

    $result = $connect->query("SHOW TABLES LIKE 'Payment_report'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE Payment_report (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        id_user varchar(200),
        id_order varchar(2000),
        time varchar(200)  NULL,
        at_updated varchar(200)  NULL,
        price varchar(200) NULL,
        dec_not_confirmed TEXT NULL,
        Payment_Method varchar(400) NULL,
        payment_Status varchar(100) NULL,
        bottype varchar(300) NULL,
        message_id INT NULL,
        id_invoice varchar(1000) NULL)");
        if (!$result) {
            echo "table Payment_report" . mysqli_error($connect);
        }
    } else {
        addFieldToTable("Payment_report", "message_id", null, "INT");
        $Check_filde = $connect->query("SHOW COLUMNS FROM Payment_report LIKE 'Payment_Method'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE Payment_report ADD Payment_Method VARCHAR(200)");
            echo "The Payment_Method field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM Payment_report LIKE 'bottype'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE Payment_report ADD bottype VARCHAR(300)");
            echo "The bottype field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM Payment_report LIKE 'at_updated'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE Payment_report ADD at_updated VARCHAR(200)");
            echo "The at_updated field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM Payment_report LIKE 'id_invoice'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE Payment_report ADD id_invoice VARCHAR(400)");
            $connect->query("UPDATE Payment_report SET id_invoice = 'none'");
            echo "The id_invoice field was added ✅";
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
//-----------------------------------------------------------------
try {

    $result = $connect->query("SHOW TABLES LIKE 'Discount'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE Discount (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        code varchar(2000) NULL,
        price varchar(200) NULL,
        limituse varchar(200) NULL,
        limitused varchar(200) NULL)
        ");
        if (!$result) {
            echo "table Discount" . mysqli_error($connect);
        }
    } else {
        $Check_filde = $connect->query("SHOW COLUMNS FROM Discount LIKE 'limituse'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE Discount ADD limituse VARCHAR(200)");
            echo "The limituse field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM Discount LIKE 'limitused'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE Discount ADD limitused VARCHAR(200)");
            echo "The limitused field was added ✅";
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
//-----------------------------------------------------------------
try {

    $result = $connect->query("SHOW TABLES LIKE 'Giftcodeconsumed'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE  Giftcodeconsumed (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        code varchar(2000) NULL,
        id_user varchar(200) NULL)");
        if (!$result) {
            echo "table Giftcodeconsumed" . mysqli_error($connect);
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
//-----------------------------------------------------------------
try {
    $result = $connect->query("SHOW TABLES LIKE 'textbot'");
    $table_exists = ($result->num_rows > 0);
    $text_roll = "
♨️ قوانین استفاده از خدمات ما

1- به اطلاعیه هایی که داخل کانال گذاشته می شود حتما توجه کنید.
2- در صورتی که اطلاعیه ای در مورد قطعی در کانال گذاشته نشده به اکانت پشتیبانی پیام دهید
3- سرویس ها را از طریق پیامک ارسال نکنید برای ارسال پیامک می توانید از طریق ایمیل ارسال کنید.
    ";
    $text_dec_fq = " 
 💡 سوالات متداول ⁉️

1️⃣ فیلترشکن شما آیپی ثابته؟ میتونم برای صرافی های ارز دیجیتال استفاده کنم؟

✅ به دلیل وضعیت نت و محدودیت های کشور سرویس ما مناسب ترید نیست و فقط لوکیشن‌ ثابته.

2️⃣ اگه قبل از منقضی شدن اکانت، تمدیدش کنم روزهای باقی مانده می سوزد؟

✅ خیر، روزهای باقیمونده اکانت موقع تمدید حساب میشن و اگه مثلا 5 روز قبل از منقضی شدن اکانت 1 ماهه خودتون اون رو تمدید کنید 5 روز باقیمونده + 30 روز تمدید میشه.

3️⃣ اگه به یک اکانت بیشتر از حد مجاز متصل شیم چه اتفاقی میافته؟

✅ در این صورت حجم سرویس شما زود تمام خواهد شد.

4️⃣ فیلترشکن شما از چه نوعیه؟

✅ فیلترشکن های ما v2ray است و پروتکل‌های مختلفی رو ساپورت میکنیم تا حتی تو دورانی که اینترنت اختلال داره بدون مشکل و افت سرعت بتونید از سرویستون استفاده کنید.

5️⃣ فیلترشکن از کدوم کشور است؟

✅ سرور فیلترشکن ما از کشور  آلمان است

6️⃣ چطور باید از این فیلترشکن استفاده کنم؟

✅ برای آموزش استفاده از برنامه، روی دکمه «📚 آموزش» بزنید.

7️⃣ فیلترشکن وصل نمیشه، چیکار کنم؟

✅ به همراه یک عکس از پیغام خطایی که میگیرید به پشتیبانی مراجعه کنید.

8️⃣ فیلترشکن شما تضمینی هست که همیشه مواقع متصل بشه؟

✅ به دلیل قابل پیش‌بینی نبودن وضعیت نت کشور، امکان دادن تضمین نیست فقط می‌تونیم تضمین کنیم که تمام تلاشمون رو برای ارائه سرویس هر چه بهتر انجام بدیم.

9️⃣ امکان بازگشت وجه دارید؟

✅ امکان بازگشت وجه در صورت حل نشدن مشکل از سمت ما وجود دارد.

💡 در صورتی که جواب سوالتون رو نگرفتید میتونید به «پشتیبانی» مراجعه کنید.";
    $text_channel = "   
        ⚠️ کاربر گرامی؛ شما عضو چنل ما نیستید
از طریق دکمه زیر وارد کانال شده و عضو شوید
پس از عضویت دکمه بررسی عضویت را کلیک کنید";
    $text_invoice = "📇 پیش فاکتور شما:
👤 نام کاربری:  {username}
🔐 نام سرویس: {name_product}
📆 مدت اعتبار: {Service_time} روز
💶 قیمت:  {price} تومان
👥 حجم اکانت: {Volume} گیگ
🗒 یادداشت محصول : {note}
💵 موجودی کیف پول شما : {userBalance}
          
💰 سفارش شما آماده پرداخت است";
    $textafterpay = "✅ سرویس با موفقیت ایجاد شد

👤 نام کاربری سرویس : {username}
🌿 نام سرویس:  {name_service}
‏🇺🇳 لوکیشن: {location}
⏳ مدت زمان: {day}  روز
🗜 حجم سرویس:  {volume} گیگابایت

لینک اتصال:
{config}
{links}
🧑‍🦯 شما میتوانید شیوه اتصال را  با فشردن دکمه زیر و انتخاب سیستم عامل خود را دریافت کنید";
    $text_wgdashboard = "✅ سرویس با موفقیت ایجاد شد

👤 نام کاربری سرویس : {username}
🌿 نام سرویس:  {name_service}
‏🇺🇳 لوکیشن: {location}
⏳ مدت زمان: {day}  روز
🗜 حجم سرویس:  {volume} گیگابایت

🧑‍🦯 شما میتوانید شیوه اتصال را  با فشردن دکمه زیر و انتخاب سیستم عامل خود را دریافت کنید";
    $textafterpayibsng = "✅ سرویس با موفقیت ایجاد شد

👤 نام کاربری سرویس : {username}
🔑 رمز عبور سرویس :  <code>{password}</code>
🌿 نام سرویس:  {name_service}
‏🇺🇳 لوکیشن: {location}
⏳ مدت زمان: {day}  روز
🗜 حجم سرویس:  {volume} گیگابایت

🧑‍🦯 شما میتوانید شیوه اتصال را  با فشردن دکمه زیر و انتخاب سیستم عامل خود را دریافت کنید";
    $textmanual = "✅ سرویس با موفقیت ایجاد شد

👤 نام کاربری سرویس : {username}
🌿 نام سرویس:  {name_service}
‏🇺🇳 لوکیشن: {location}

 اطلاعات سرویس :
{config}
🧑‍🦯 شما میتوانید شیوه اتصال را  با فشردن دکمه زیر و انتخاب سیستم عامل خود را دریافت کنید";
    $textaftertext = "✅ سرویس با موفقیت ایجاد شد

👤 نام کاربری سرویس : {username}
🌿 نام سرویس:  {name_service}
‏🇺🇳 لوکیشن: {location}
⏳ مدت زمان: {day}  ساعت
🗜 حجم سرویس:  {volume} مگابایت

لینک اتصال:
{config}
🧑‍🦯 شما میتوانید شیوه اتصال را  با فشردن دکمه زیر و انتخاب سیستم عامل خود را دریافت کنید";
    $textconfigtest = "با سلام خدمت شما کاربر گرامی 
سرویس تست شما با نام کاربری {username} به پایان رسیده است
امیدواریم تجربه‌ی خوبی از آسودگی و سرعت سرویستون داشته باشین. در صورتی که از سرویس‌ تست خودتون راضی بودین، میتونید سرویس اختصاصی خودتون رو تهیه کنید و از داشتن اینترنت آزاد با نهایت کیفیت لذت ببرید😉🔥
🛍 برای تهیه سرویس با کیفیت می توانید از دکمه زیر استفاده نمایید";
    $textcart = "برای افزایش موجودی، مبلغ <code>{price}</code>  تومان  را به شماره‌ی حساب زیر واریز کنید 👇🏻
        
        ==================== 
        <code>{card_number}</code>
        {name_card}
        ====================

❌ این تراکنش به مدت یک ساعت اعتبار دارد پس از آن امکان پرداخت این تراکنش امکان ندارد.        
‼مبلغ باید همان مبلغی که در بالا ذکر شده واریز نمایید.
‼️امکان برداشت وجه از کیف پول نیست.
‼️مسئولیت واریز اشتباهی با شماست.
🔝بعد از پرداخت  دکمه پرداخت کردم را زده سپس تصویر رسید را ارسال نمایید
💵بعد از تایید پرداختتون توسط ادمین کیف پول شما شارژ خواهد شد و در صورتی که سفارشی داشته باشین انجام خواهد شد";
    $textcartauto = "برای تایید فوری لطفا دقیقاً مبلغ زیر واریز شود. در غیر این صورت تایید پرداخت شما ممکن است با تاخیر مواجه شود.⚠️
            برای افزایش موجودی، مبلغ <code>{price}</code>  ریال  را به شماره‌ی حساب زیر واریز کنید 👇🏻

        ==================== 
        <code>{card_number}</code>
        {name_card}
        ====================
        
💰دقیقا مبلغی را که در بالا ذکر شده واریز نمایید تا بصورت آنی تایید شود.
‼️امکان برداشت وجه از کیف پول نیست.
🔝لزومی به ارسال رسید نیست، اما در صورتی که بعد از گذشت مدتی واریز شما تایید نشد، عکس رسید خود را ارسال کنید.";
    $insertQueries = [
        ['text_start', 'سلام خوش آمدید'],
        ['text_usertest', '🔑 اکانت تست'],
        ['text_Purchased_services', '🛍 سرویس های من'],
        ['text_support', '☎️ پشتیبانی'],
        ['text_help', '📚 آموزش'],
        ['text_bot_off', '❌ ربات خاموش است، لطفا دقایقی دیگر مراجعه کنید'],
        ['text_roll', $text_roll],
        ['text_fq', '❓ سوالات متداول'],
        ['text_dec_fq', $text_dec_fq],
        ['text_sell', '🔐 خرید اشتراک'],
        ['text_Add_Balance', '💰 افزایش موجودی'],
        ['text_channel', $text_channel],
        ['text_Discount', '🎁 کد هدیه'],
        ['text_Tariff_list', '💵 تعرفه اشتراک ها'],
        ['text_dec_Tariff_list', 'تنظیم نشده است'],
        ['text_Account_op', '🎛 حساب کاربری'],
        ['text_affiliates', '👥 زیر مجموعه گیری'],
        ['text_pishinvoice', $text_invoice],
        ['accountwallet', '🏦 کیف پول + شارژ'],
        ['carttocart', '💳 کارت به کارت'],
        ['textnowpayment', '💵 پرداخت ارزی 1'],
        ['textnowpaymenttron', '💵 واریز رمزارز ترون'],
        ['textsnowpayment', '💸 پرداخت با ارز دیجیتال'],
        ['iranpay1', '💸 درگاه  پرداخت ریالی'],
        ['iranpay2', '💸 درگاه  پرداخت ریالی دوم'],
        ['iranpay3', '💸 درگاه  پرداخت ریالی سوم'],
        ['aqayepardakht', '🔵 درگاه آقای پرداخت'],
        ['mowpayment', '💸 پرداخت با ارز دیجیتال'],
        ['zarinpal', '🟡 زرین پال'],
        ['textafterpay', $textafterpay],
        ['textafterpayibsng', $textafterpayibsng],
        ['textaftertext', $textaftertext],
        ['textmanual', $textmanual],
        ['textselectlocation', '📌 موقعیت سرویس را انتخاب نمایید.'],
        ['crontest', $textconfigtest],
        ['textpaymentnotverify', 'درگاه ریالی'],
        ['textrequestagent', '👨‍💻 درخواست نمایندگی'],
        ['textpanelagent', '👨‍💻 پنل نمایندگی'],
        ['text_wheel_luck', '🎲 گردونه شانس'],
        ['text_cart', $textcart],
        ['text_cart_auto', $textcartauto],
        ['text_star_telegram', "💫 Star Telegram"],
        ['text_request_agent_dec', '📌 توضیحات خود را برای ثبت درخواست نمایندگی ارسال نمایید.'],
        ['text_extend', '♻️ تمدید سرویس'],
        ['text_wgdashboard', $text_wgdashboard]
    ];
    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE textbot (
        id_text varchar(600) PRIMARY KEY NOT NULL,
        text TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table textbot" . mysqli_error($connect);
        }

        foreach ($insertQueries as $query) {
            $connect->query("INSERT INTO textbot (id_text, text) VALUES ('$query[0]', '$query[1]')");
        }
    } else {
        foreach ($insertQueries as $query) {
            $connect->query("INSERT IGNORE INTO textbot (id_text, text) VALUES ('$query[0]', '$query[1]')");
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}

try {
    $result = $connect->query("SHOW TABLES LIKE 'PaySetting'");
    $table_exists = ($result->num_rows > 0);
    $main = 20000;
    $max = 1000000;
    $settings = [
        ['Cartstatus', 'oncard'],
        ['CartDirect', '@cart'],
        ['cardnumber', '603700000000'],
        ['namecard', 'تنظیم نشده'],
        ['Cartstatuspv', 'offcardpv'],
        ['apinowpayment', '0'],
        ['nowpaymentstatus', 'offnowpayment'],
        ['digistatus', 'offdigi'],
        ['statusSwapWallet', 'offnSolutions'],
        ['statusaqayepardakht', 'offaqayepardakht'],
        ['merchant_id_aqayepardakht', '0'],
        ['minbalance', '20000'],
        ['maxbalance', '1000000'],
        ['marchent_tronseller', '0'],
        ['walletaddress', '0'],
        ['statuscardautoconfirm', 'offautoconfirm'],
        ['urlpaymenttron', 'https://tronseller.storeddownloader.fun/api/GetOrderToken'],
        ['statustarnado', 'offternado'],
        ['apiternado', '0'],
        ['chashbackcart', '0'],
        ['chashbackstar', '0'],
        ['chashbackperfect', '0'],
        ['chashbackaqaypardokht', '0'],
        ['chashbackiranpay1', '0'],
        ['chashbackiranpay2', '0'],
        ['chashbackplisio', '0'],
        ['chashbackzarinpal', '0'],
        ['checkpaycartfirst', 'offpayverify'],
        ['zarinpalstatus', 'offzarinpal'],
        ['merchant_zarinpal', '0'],
        ['minbalancecart', $main],
        ['maxbalancecart', $max],
        ['minbalancestar', $main],
        ['maxbalancestar', $max],
        ['minbalanceplisio', $main],
        ['maxbalanceplisio', $max],
        ['minbalancedigitaltron', $main],
        ['maxbalancedigitaltron', $max],
        ['minbalanceiranpay1', $main],
        ['maxbalanceiranpay1', $max],
        ['minbalanceiranpay2', $main],
        ['maxbalanceiranpay2', $max],
        ['minbalanceaqayepardakht', $main],
        ['maxbalanceaqayepardakht', $max],
        ['minbalancepaynotverify', $main],
        ['maxbalancepaynotverify', $max],
        ['minbalanceperfect', $main],
        ['maxbalanceperfect', $max],
        ['minbalancezarinpal', $main],
        ['maxbalancezarinpal', $max],
        ['minbalanceiranpay', $main],
        ['maxbalanceiranpay', $max],
        ['minbalancenowpayment', $main],
        ['maxbalancenowpayment', $max],
        ['statusiranpay3', 'oniranpay3'],
        ['apiiranpay', '0'],
        ['chashbackiranpay3', '0'],
        ['helpcart', '2'],
        ['helpaqayepardakht', '2'],
        ['helpstar', '2'],
        ['helpplisio', '2'],
        ['helpiranpay1', '2'],
        ['helpiranpay2', '2'],
        ['helpiranpay3', '2'],
        ['helpperfectmony', '2'],
        ['helpzarinpal', '2'],
        ['helpnowpayment', '2'],
        ['helpofflinearze', '2'],
        ['autoconfirmcart', 'offauto'],
        ['cashbacknowpayment', '0'],
        ['statusstar', '0'],
        ['statusnowpayment', '0'],
        ['Exception_auto_cart', '{}'],
        ['marchent_floypay', '0'],
    ];
    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE PaySetting (
        NamePay varchar(500) PRIMARY KEY NOT NULL,
        ValuePay TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table PaySetting" . mysqli_error($connect);
        }

        foreach ($settings as $setting) {
            $connect->query("INSERT INTO PaySetting (NamePay, ValuePay) VALUES ('{$setting[0]}', '{$setting[1]}')");
        }
    } else {
        foreach ($settings as $setting) {
            $connect->query("INSERT IGNORE INTO PaySetting (NamePay, ValuePay) VALUES ('{$setting[0]}', '{$setting[1]}')");
        }





    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
//----------------------- [ Discount ] --------------------- //
try {
    $result = $connect->query("SHOW TABLES LIKE 'DiscountSell'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE DiscountSell (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        codeDiscount varchar(1000)  NOT NULL,
        price varchar(200)  NOT NULL,
        limitDiscount varchar(500)  NOT NULL,
        agent varchar(500)  NOT NULL,
        usefirst varchar(100)  NOT NULL,
        useuser varchar(100)  NOT NULL,
        code_product varchar(100)  NOT NULL,
        code_panel varchar(100)  NOT NULL,
        time varchar(100)  NOT NULL,
        type varchar(100)  NOT NULL,
        usedDiscount varchar(500) NOT NULL)");
        if (!$result) {
            echo "table DiscountSell" . mysqli_error($connect);
        }
    } else {
        $Check_filde = $connect->query("SHOW COLUMNS FROM DiscountSell LIKE 'agent'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE DiscountSell ADD agent VARCHAR(100)");
            echo "The agent discount field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM DiscountSell LIKE 'type'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE DiscountSell ADD type VARCHAR(100)");
            echo "The agent type field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM DiscountSell LIKE 'time'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE DiscountSell ADD time VARCHAR(100)");
            echo "The agent time field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM DiscountSell LIKE 'code_panel'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE DiscountSell ADD code_panel VARCHAR(100)");
            echo "The code_panel discount field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM DiscountSell LIKE 'code_product'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE DiscountSell ADD code_product VARCHAR(100)");
            echo "The code_product discount field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM DiscountSell LIKE 'useuser'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE DiscountSell ADD useuser VARCHAR(100)");
            echo "The useuser discount field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM DiscountSell LIKE 'usefirst'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE DiscountSell ADD usefirst VARCHAR(100)");
            echo "The usefirst discount field was added ✅";
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
//-----------------------------------------------------------------
try {
    $result = $connect->query("SHOW TABLES LIKE 'affiliates'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE affiliates (
        description TEXT  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NULL,
        status_commission varchar(200)  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NULL,
        Discount varchar(200)  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NULL,
        price_Discount varchar(200)  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NULL,
        porsant_one_buy varchar(100),
        id_media varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table affiliates" . mysqli_error($connect);
        }
        $connect->query("INSERT INTO affiliates (description,id_media,status_commission,Discount,porsant_one_buy) VALUES ('none','none','oncommission','onDiscountaffiliates','off_buy_porsant')");
    } else {
        $Check_filde = $connect->query("SHOW COLUMNS FROM affiliates LIKE 'porsant_one_buy'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE affiliates ADD porsant_one_buy VARCHAR(100)");
            $connect->query("UPDATE affiliates SET porsant_one_buy = 'off_buy_porsant'");
            echo "The Discount field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM affiliates LIKE 'Discount'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE affiliates ADD Discount VARCHAR(100)");
            $connect->query("UPDATE affiliates SET Discount = 'onDiscountaffiliates'");
            echo "The Discount field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM affiliates LIKE 'price_Discount'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE affiliates ADD price_Discount VARCHAR(100)");
            echo "The price_Discount field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM affiliates LIKE 'status_commission'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE affiliates ADD status_commission VARCHAR(100)");
            $connect->query("UPDATE affiliates SET status_commission = 'oncommission'");
            echo "The commission field was added ✅";
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
try {
    $result = $connect->query("SHOW TABLES LIKE 'shopSetting'");
    $table_exists = ($result->num_rows > 0);
    $agent_cashback = json_encode(array(
        'n' => 0,
        'n2' => 0
    ));
    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE shopSetting (
        Namevalue varchar(500) PRIMARY KEY NOT NULL,
        value TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table shopSetting" . mysqli_error($connect);
        }
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('customvolmef','4000')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('customvolmen','4000')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('customvolmen2','4000')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('statusextra','offextra')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('customtimepricef','4000')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('customtimepricen','4000')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('customtimepricen2','4000')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('statusdirectpabuy','ondirectbuy')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('minbalancebuybulk','0')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('statustimeextra','ontimeextraa')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('statusdisorder','offdisorder')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('statuschangeservice','onstatus')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('statusshowprice','offshowprice')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('configshow','onconfig')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('backserviecstatus','on')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('chashbackextend','0')");
        $connect->query("INSERT INTO shopSetting (Namevalue,value) VALUES ('chashbackextend_agent','$agent_cashback')");
    } else {
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('customvolmef','4000')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('customvolmen','4000')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('customvolmen2','4000')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('statusextra','offextra')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('statusdirectpabuy','ondirectbuy')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('minbalancebuybulk','0')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('statustimeextra','ontimeextraa')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('customtimepricef','4000')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('customtimepricen','4000')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('customtimepricen2','4000')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('statusdisorder','offdisorder')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('statuschangeservice','onstatus')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('statusshowprice','offshowprice')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('configshow','onconfig')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('backserviecstatus','on')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('chashbackextend','0')");
        $connect->query("INSERT IGNORE INTO shopSetting (Namevalue,value) VALUES ('chashbackextend_agent','$agent_cashback')");



    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
//----------------------- [ remove requests ] --------------------- //
try {
    $result = $connect->query("SHOW TABLES LIKE 'cancel_service'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE cancel_service (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        id_user varchar(500)  NOT NULL,
        username varchar(1000)  NOT NULL,
        description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL,
        status varchar(1000)  NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table cancel_service" . mysqli_error($connect);
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
try {
    $result = $connect->query("SHOW TABLES LIKE 'service_other'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE service_other (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        id_user varchar(500)  NOT NULL,
        username varchar(1000)  NOT NULL,
        value varchar(1000)  NOT NULL,
        time varchar(200)  NOT NULL,
        price varchar(200)  NOT NULL,
        type varchar(1000)  NOT NULL,
        status varchar(200)  NOT NULL,
        output TEXT  NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table service_other" . mysqli_error($connect);
        }
    } else {
        $Check_filde = $connect->query("SHOW COLUMNS FROM service_other LIKE 'price'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE service_other ADD price VARCHAR(200)");
            echo "The price field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM service_other LIKE 'status'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE service_other ADD status VARCHAR(200)");
            echo "The status field was added ✅";
        }
        $Check_filde = $connect->query("SHOW COLUMNS FROM service_other LIKE 'output'");
        if (mysqli_num_rows($Check_filde) != 1) {
            $connect->query("ALTER TABLE service_other ADD output TEXT");
            echo "The output field was added ✅";
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
try {
    $result = $connect->query("SHOW TABLES LIKE 'card_number'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE card_number (
        cardnumber varchar(500) PRIMARY KEY,
        namecard  varchar(1000)  NOT NULL)
        ");
        if (!$result) {
            echo "table x_ui" . mysqli_error($connect);
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log card_number', $e->getMessage());
}
try {
    $result = $connect->query("SHOW TABLES LIKE 'Requestagent'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE Requestagent (
        id varchar(500) PRIMARY KEY,
        username  varchar(500)  NOT NULL,
        time  varchar(500)  NOT NULL,
        Description  varchar(500)  NOT NULL,
        status  varchar(500)  NOT NULL,
        type  varchar(500)  NOT NULL)");
        if (!$result) {
            echo "table Requestagent" . mysqli_error($connect);
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log Requestagent', $e->getMessage());
}
try {
    $result = $connect->query("SHOW TABLES LIKE 'topicid'");
    $table_exists = ($result->num_rows > 0);
    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE topicid (
        report varchar(500) PRIMARY KEY NOT NULL,
        idreport TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table Requestagent" . mysqli_error($connect);
        }
        $connect->query("INSERT INTO topicid (idreport,report) VALUES ('0','buyreport')");
        $connect->query("INSERT INTO topicid (idreport,report) VALUES ('0','otherservice')");
        $connect->query("INSERT INTO topicid (idreport,report) VALUES ('0','paymentreport')");
        $connect->query("INSERT INTO topicid (idreport,report) VALUES ('0','otherreport')");
        $connect->query("INSERT INTO topicid (idreport,report) VALUES ('0','reporttest')");
        $connect->query("INSERT INTO topicid (idreport,report) VALUES ('0','errorreport')");
        $connect->query("INSERT INTO topicid (idreport,report) VALUES ('0','porsantreport')");
        $connect->query("INSERT INTO topicid (idreport,report) VALUES ('0','reportnight')");
        $connect->query("INSERT INTO topicid (idreport,report) VALUES ('0','reportcron')");
        $connect->query("INSERT INTO topicid (idreport,report) VALUES ('0','backupfile')");
    } else {
        $connect->query("INSERT IGNORE INTO topicid (idreport,report) VALUES ('0','buyreport')");
        $connect->query("INSERT IGNORE INTO topicid (idreport,report) VALUES ('0','otherservice')");
        $connect->query("INSERT IGNORE INTO topicid (idreport,report) VALUES ('0','paymentreport')");
        $connect->query("INSERT IGNORE INTO topicid (idreport,report) VALUES ('0','otherreport')");
        $connect->query("INSERT IGNORE INTO topicid (idreport,report) VALUES ('0','reporttest')");
        $connect->query("INSERT IGNORE INTO topicid (idreport,report) VALUES ('0','errorreport')");
        $connect->query("INSERT IGNORE INTO topicid (idreport,report) VALUES ('0','porsantreport')");
        $connect->query("INSERT IGNORE INTO topicid (idreport,report) VALUES ('0','reportnight')");
        $connect->query("INSERT IGNORE INTO topicid (idreport,report) VALUES ('0','reportcron')");
        $connect->query("INSERT IGNORE INTO topicid (idreport,report) VALUES ('0','backupfile')");




    }
} catch (Exception $e) {
    file_put_contents('error_log topicid', $e->getMessage());
}
try {
    $result = $connect->query("SHOW TABLES LIKE 'manualsell'");
    $table_exists = ($result->num_rows > 0);
    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE manualsell (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        codepanel  varchar(100)  NOT NULL,
        codeproduct  varchar(100)  NOT NULL,
        namerecord  varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL,
        username  varchar(500)  NULL,
        contentrecord  TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL,
        status  varchar(200)  NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table manualsell" . mysqli_error($connect);
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log manualsell', $e->getMessage());
}
//-----------------------------------------------------------------
try {

    $tableName = 'departman';
    $stmt = $pdo->prepare("SELECT 1 FROM information_schema.tables WHERE table_name = :tableName");
    $stmt->bindParam(':tableName', $tableName);
    $stmt->execute();
    $tableExists = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$tableExists) {
        $stmt = $pdo->prepare("CREATE TABLE $tableName (
            id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            idsupport VARCHAR(200) NOT NULL,
            name_departman VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        $stmt->execute();
        $connect->query("INSERT INTO departman (idsupport,name_departman) VALUES ('$adminnumber','☎️ بخش عمومی')");
    }
} catch (PDOException $e) {
    file_put_contents('error_log departman', $e->getMessage());
}
try {

    $tableName = 'support_message';
    $stmt = $pdo->prepare("SELECT 1 FROM information_schema.tables WHERE table_name = :tableName");
    $stmt->bindParam(':tableName', $tableName);
    $stmt->execute();
    $tableExists = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$tableExists) {
        $stmt = $pdo->prepare("CREATE TABLE $tableName (
            id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            Tracking VARCHAR(100) NOT NULL,
            idsupport VARCHAR(100) NOT NULL,
            iduser VARCHAR(100) NOT NULL,
            name_departman VARCHAR(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            text TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            result TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
            time VARCHAR(200) NOT NULL,
            status ENUM('Answered','Pending','Unseen','Customerresponse','close') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        $stmt->execute();
    } else {
        addFieldToTable("support_message", "result", "0", "TEXT");
    }
} catch (PDOException $e) {
    file_put_contents('error_log suppeor_message', $e->getMessage());
}
try {
    $result = $connect->query("SHOW TABLES LIKE 'wheel_list'");
    $table_exists = ($result->num_rows > 0);
    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE wheel_list (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        id_user  varchar(200)  NOT NULL,
        time  varchar(200)  NOT NULL,
        first_name  varchar(200)  NOT NULL,
        wheel_code  varchar(200)  NOT NULL,
        price  varchar(200)  NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table wheel_list" . mysqli_error($connect);
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log botsaz', $e->getMessage());
}
try {
    $result = $connect->query("SHOW TABLES LIKE 'botsaz'");
    $table_exists = ($result->num_rows > 0);
    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE botsaz (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        id_user  varchar(200)  NOT NULL,
        bot_token  varchar(200)  NOT NULL,
        admin_ids  TEXT  NOT NULL,
        username  varchar(200)  NOT NULL,
        setting  TEXT  NULL,
        hide_panel  JSON  NOT NULL,
        time  varchar(200)  NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table botsaz" . mysqli_error($connect);
        }
    } else {
        addFieldToTable("botsaz", "hide_panel", "{}", "JSON");
    }
} catch (Exception $e) {
    file_put_contents('error_log botsaz', $e->getMessage());
}

try {
    $result = $connect->query("SHOW TABLES LIKE 'app'");
    $table_exists = ($result->num_rows > 0);
    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE app (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        name  varchar(200)   CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        link  varchar(200)  NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table app" . mysqli_error($connect);
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log app', $e->getMessage());
}



try {
    $result = $connect->query("SHOW TABLES LIKE 'logs_api'");
    $table_exists = ($result->num_rows > 0);
    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE logs_api (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        header JSON  NULL,
        data JSON  NULL,
        ip  varchar(200)  NOT NULL,
        time  varchar(200)  NOT NULL,
        actions  varchar(200)  NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci");
        if (!$result) {
            echo "table logs_api" . mysqli_error($connect);
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log logs_api', $e->getMessage());
}
//----------------------- [ Category ] --------------------- //
try {
    $result = $connect->query("SHOW TABLES LIKE 'category'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE category (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        remark varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin  NOT NULL)
        ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin");
        if (!$result) {
            echo "table category" . mysqli_error($connect);
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}
try {
    $result = $connect->query("SHOW TABLES LIKE 'reagent_report'");
    $table_exists = ($result->num_rows > 0);

    if (!$table_exists) {
        $result = $connect->query("CREATE TABLE reagent_report (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        user_id BIGINT UNIQUE  NOT NULL,
        get_gift BOOL   NOT NULL,
        time varchar(50)  NOT NULL,
        reagent varchar(30)  NOT NULL
        )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin");
        if (!$result) {
            echo "table affiliates" . mysqli_error($connect);
        }
    }
} catch (Exception $e) {
    file_put_contents('error_log', $e->getMessage());
}



$balancemain = json_decode(select("PaySetting", "ValuePay", "NamePay", "maxbalance", "select")['ValuePay'], true);
if (!isset($balancemain['f'])) {
    $value = json_encode(array(
        "f" => "1000000",
        "n" => "1000000",
        "n2" => "1000000",
    ));
    $valuemain = json_encode(array(
        "f" => "20000",
        "n" => "20000",
        "n2" => "20000",
    ));
    update("PaySetting", "ValuePay", $value, "NamePay", "maxbalance");
    update("PaySetting", "ValuePay", $valuemain, "NamePay", "minbalance");
}
$connect->query("ALTER TABLE `invoice` CHANGE `Volume` `Volume` VARCHAR(200)");
$connect->query("ALTER TABLE `invoice` CHANGE `price_product` `price_product` VARCHAR(200)");
$connect->query("ALTER TABLE `invoice` CHANGE `name_product` `name_product` VARCHAR(200)");
$connect->query("ALTER TABLE `invoice` CHANGE `username` `username` VARCHAR(200)");
$connect->query("ALTER TABLE `invoice` CHANGE `Service_location` `Service_location` VARCHAR(200)");
$connect->query("ALTER TABLE `invoice` CHANGE `time_sell` `time_sell` VARCHAR(200)");
$connect->query("ALTER TABLE marzban_panel MODIFY name_panel VARCHAR(255) COLLATE utf8mb4_bin");
$connect->query("ALTER TABLE product MODIFY name_product VARCHAR(255) COLLATE utf8mb4_bin");
$connect->query("ALTER TABLE help MODIFY name_os VARCHAR(500) COLLATE utf8mb4_bin");
telegram('setwebhook', [
    'url' => "https://$domainhosts/index.php"
]);
