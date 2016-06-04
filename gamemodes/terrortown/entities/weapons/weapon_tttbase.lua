<?php


# ------------------------------------- Config Begin ------------------------------------- #
// ------------------------------------------------------------------------------------------------
/* MySQL Config | Begin */
// Hostname ของ MySQL Server
$_CONFIG['mysql']['dbhost'] = 'localhost';
// Username ที่ใช้เชื่อมต่อ MySQL Server
$_CONFIG['mysql']['dbuser'] = 'u353898514_prome';
// Password ที่ใช้เชื่อมต่อ MySQL Server
$_CONFIG['mysql']['dbpw'] = '02520286';
// ชื่อฐานข้อมูลที่เราจะเติม Point ให้
$_CONFIG['mysql']['dbname'] = 'u353898514_prome';
// ชื่อตารางที่เราจะเติม Point ให้ ตัวอย่าง : member
$_CONFIG['mysql']['tbname'] = 'players';
// ชื่อ field ที่ใช้อ้าง Username
$_CONFIG['mysql']['field_username'] = 'ref2';
// ชื่อ field ที่ใช้ในการเก็บ Point จากการเติมเงิน
$_CONFIG['TMN']['point_field_name'] = 'credits';
/* MySQL Config | End */
// ------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------
/* จำนวน Point ที่จะได้รับเมื่อเติมเงินในราคาต่างๆ | Begin */
$_CONFIG['TMN'][50]['point'] = 43;					// Point ที่ได้รับเมื่อเติมเงินราคา 50 บาท
$_CONFIG['TMN'][90]['point'] = 77;					// Point ที่ได้รับเมื่อเติมเงินราคา 90 บาท
$_CONFIG['TMN'][150]['point'] = 128;				// Point ที่ได้รับเมื่อเติมเงินราคา 150 บาท
$_CONFIG['TMN'][300]['point'] = 255;				// Point ที่ได้รับเมื่อเติมเงินราคา 300 บาท
$_CONFIG['TMN'][500]['point'] = 426;				// Point ที่ได้รับเมื่อเติมเงินราคา 500 บาท
$_CONFIG['TMN'][1000]['point'] = 851;				// Point ที่ได้รับเมื่อเติมเงินราคา 1,000 บาท
/* จำนวน Point ที่จะได้รับเมื่อเติมเงินในราคาต่างๆ | End */
// ------------------------------------------------------------------------------------------------
// กำหนด API Passkey
define('API_PASSKEY', 'i74445YqL168');
# -------------------------------------- Config End -------------------------------------- #
require_once('AES.php');
// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
if($_SERVER['REMOTE_ADDR'] == '203.146.127.115' && isset($_GET['request']))
{
	$aes = new Crypt_AES();
	$aes->setKey(API_PASSKEY);
	$_GET['request'] = base64_decode(strtr($_GET['request'], '-_,', '+/='));
	$_GET['request'] = $aes->decrypt($_GET['request']);
	if($_GET['request'] != false)
	{
		parse_str($_GET['request'],$request);
		$request['Ref1'] = base64_decode($request['Ref1']);
		/* Database connection | Begin */
		$result = mysql_query('SELECT * FROM `'. $_CONFIG['mysql']['tbname'] .'` WHERE `'. $_CONFIG['mysql']['field_username'] .'`=\'' . mysql_real_escape_string($request['Ref1']) . '\' LIMIT 1') or die(mysql_error());
		if(mysql_num_rows($result) == 1)
		{
			$row = mysql_fetch_assoc($result);
			if(mysql_query("UPDATE `". $_CONFIG['mysql']['tbname'] ."` SET `". $_CONFIG['TMN']['point_field_name'] ."` = `". $_CONFIG['TMN']['point_field_name'] ."`+'". $_CONFIG['TMN'][$request['cardcard_amount']]['point'] ."' WHERE `". $_CONFIG['mysql']['field_username'] ."` = '". $row[$_CONFIG['mysql']['field_username']] ."' LIMIT 1 ") == false)
			{
				echo 'ERROR|MYSQL_UDT_ERROR|' . mysql_error();
			}
			else
			{
				echo 'SUCCEED|UID=' . $row[$_CONFIG['mysql']['field_username']];
			}
		}
		else
		{
			echo 'ERROR|INCORRECT_USERNAME';
		}
		/* Database connection | End */
	}
	else
	{
		echo 'ERROR|INVALID_PASSKEY';
	}
}
else
{
	echo 'ERROR|ACCESS_DENIED';
}
/*-----------------TRUEMONEY----------------*/





SESSION_START();

$page = 'truemoney';
$page_title = 'Truemoney';

include('inc/functions.php');

$message = new FlashMessages();

if (!prometheus::loggedin()) {
    include('inc/login.php');
}

if (isset($_POST['reply_submit'])) {
    if(isset($_SESSION['lastVisit'])){
        $lastVisit = $_SESSION['lastVisit'];

    }

    $_SESSION['lastPurchase'] = time();

    tickets::addReply($_GET['view'], $_POST['reply'], 0);
}

if (isset($_POST['ticket_close'])) {
    tickets::close($_GET['view']);
}

if (isset($_POST['ticket_open'])) {
    tickets::open($_GET['view']);
}

if (isset($_POST['submit'])) {
    if(isset($_SESSION['lastVisit'])){
        $lastVisit = $_SESSION['lastVisit'];

        if(time() <= $lastVisit + 10){
            header('location: support.php');
            exit;
        }
    }

    $_SESSION['lastPurchase'] = time();

    $error = false;

    $descr = $_POST['descr'];
    $text = $_POST['text'];

    if ($descr == '') {
        $error = true;
        $message->Add('danger', 'You need to enter a description!');
    }

    if ($text == '') {
        $error = true;
        $message->Add('danger', 'You need to enter some text!');
    }

    if (!$error) {
        tickets::create(strip_tags($descr), $text);
        header('location: support.php');
    }
}
?>


<?php include('inc/header.php'); ?>
<div class="content">
    <div class="container">
        <div class="row">	

<?php if (prometheus::loggedin()) { ?>


		
<script type="text/javascript" src='https://www.tmtopup.com/topup/3rdTopup.php?uid=53920'></script>
<div class="content">
    <div class="container">
        <div class="row">
            <div class="col-xs-12">
                    <div align="center">
						<div class="row">
							<div class="col-md-offset-3 col-xs-6">
							<img src="http://1.bp.blogspot.com/-OkFa9BVX_fw/UaNb7vcEUCI/AAAAAAAAALM/wTb1SaKO3is/s320/truemoney.png"> 
								<input name="tmn_password" class="form-control" type="text" id="tmn_password" maxlength="14" placeholder="รหัสทรูมันนี 14 หลัก" required autofocus /><br>
								<input name="ref1" class="form-control" type="text" id="ref1" maxlength="14" placeholder="Email ติดต่อกลับ" /><br>
								<input name="ref2" type="hidden" id="ref2" value=<?= $UID; ?> /><br>
								<input name="ref3" type="hidden" id="ref3" value=<?= getUserSetting("name", ''); ?> /><br>
								<button type="button" class="btn btn-primary" onclick="submit_tmnc()"><i class="fa fa-check"></i> เติมเงิน !</button>
							</div>
						</div>
					</div>
                            </div>
        </div>
    </div>
</div>
    <div class="push"></div>
</div>
<?php
} else {

            echo lang('not_authorised', 'You are not authorized to view this area. Sign in first!');
}
?>



<script src="compiled/js/site.js"></script>

<script type="template" id="message-danger">
    <p class='bs-callout bs-callout-danger'>
        <button type='button' class='close' data-dismiss='alert'>&times;</button>
    </p>
</script>

<script type="template" id="message-success">
    <p class='bs-callout bs-callout-success'>
        <button type='button' class='close' data-dismiss='alert'>&times;</button>
    </p>
</script>

        </div>
    </div>
</div>


<?php include('inc/footer.php'); ?>
