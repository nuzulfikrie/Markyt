<?php
echo $this->Html->script('Bootstrap/jQuery-Knob/js/jquery.knob.min', array('block' => 'scriptInView'));
echo $this->Html->script('Bootstrap/passwordStrength.js', array('block' => 'scriptInView'));
$group_id = $this->Session->read('group_id');
?>
<div class="col-md-12">
    <?php echo $this->Form->create('User', array('type' => 'file', 'role' => 'form')); ?>
    <h1>
        <?php
        echo $this->Html->link('<i class="fa fa-eye"></i>', array(
            'action' => 'view', $this->request->data['User']['id']), array('escape' => false));
        ?>
<?php echo __('Edit User'); ?>
    </h1>
    <fieldset>
        <h3>Your image profile:</h3>
        <div class=" col-md-3">
            <div class="image-profile-container">
                <div class="img-thumbnail">
                    <?php
                    $class = "";
                    if ($this->request->data['User']['image'] != null) {
                        $class = "hidden";
                        ?>
                        <img src="<?php echo 'data:' . $this->request->data['User']['image_type'] . ';base64,' . base64_encode($this->Form->value('image')); ?>"  title="profileImage" class="imageProfile" alt="profileImage" />
                        <?php
                    }
                    ?>
                    <div class="profile-img large <?php echo $class; ?>">
                        <i class="fa fa-user fa-4"></i>
                    </div>
                    <div>
                        <div class="filePath">
                            <i class='fa fa-folder-open'></i>&nbsp;<span class='urlFile'>Image not selected</span>
                        </div>
                        <?php
                        echo $this->Form->input('image', array('type' => 'file',
                            'label' => false, 'class' => 'uploadInput hidden'));
                        echo $this->Form->button('Select an image <i class="fa fa-cloud-upload"></i>', array(
                            'class' => 'uploadFileButton btn btn-primary', 'escape' => false,
                            'type' => 'button', 'id' => 'falseUploadButton'));
                        ?>
                    </div>
                </div>
            </div>
        </div>
        <div class="dataProfile col-md-6">
            <?php
            echo $this->Form->input('id');
            if ($group_id == 1) {
                echo $this->Form->input('group_id', array('required' => false, 'class' => "chosen-select"));
            }

            echo $this->Form->input('username', array('class' => 'form-control'));
            echo $this->Form->input('surname', array('class' => 'form-control'));
            echo $this->Form->input('email', array('class' => 'form-control', "placeholder" => "user@example.com"));
            echo $this->Form->input('password', array('label' => 'Password (leave blank for no update)',
                'value' => '', 'class' => 'form-control', 'id' => 'pass'));
            ?>
            <div class="strengthContainerBackup text-center">
                <div id="passwordDescription">Password not entered</div>
                <div id="passwordStrength" class="strength0"></div>
            </div>
            <div class="strengthContainer text-center">
                <input class="knob" data-min="0" data-max="5"  data-angleOffset=-125 data-angleArc=250 data-readOnly=true>
            </div>

        </div>
    </fieldset>
    <?php
    echo $this->Form->submit('Submit', array('class' => 'btn btn-success'));
    echo $this->Form->end();
    ?>
</div>
