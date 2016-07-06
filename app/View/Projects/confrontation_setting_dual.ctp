<?php
echo $this->Html->script('Bootstrap/bootstrap-slider/bootstrap-slider.min', array('block' => 'scriptInView'));
echo $this->Html->css('../js/Bootstrap/bootstrap-slider/css/bootstrap-slider.min', array('block' => 'scriptInView'));
echo $this->Html->script('Bootstrap/markyConfrontationSettings', array('block' => 'scriptInView'));
?>
<div class="projects form">
    <div class="col-md-12">
        <h1><?php echo __('Settings for among types (quality measure between two or more types of annotations)'); ?></h1>
        <?php echo $this->Form->create('Project', array('id' => 'setForm', 'class' => 'submitForm')); ?>

        <div class="col-md-6">
            <p>
                In this section you you can get a <span class="bold">quality measure between two or more types of annotations</span>. 
                If you want to include a concordance of the following annotations, you should put a margin of 2:
            </p>
            <p>
                If you want to include a concordance of the following annotations, you should put a margin of 2:
            </p>  
            <p><span class="bold">Annotation 1:</span> A gene is a molecular unit of <mark class="annotation">heredity</mark> of a living organism.</p>
            <p><span class="bold">Annotation 2:</span> A gene is a molecular unit of <mark class="annotation">heredity o</mark>f a living organism.</p>
            <p><span class="bold">Annotation 3:</span> A gene is a molecular unit o<mark class="annotation">f heredity</mark> of a living organism.</p>

            <div class="input">
                <span class="bold">Want to send the data to your email to load later with option "load confrontation with file"?</span>
                <div class="onoffswitch">
                    <?php
//                    echo $this->Form->input('allRounds', array('label' => false, 'type' => "checkbox", "class" => "onoffswitch-checkbox", "id" => "only_abstract", "div" => false));
                    ?>
                    <?php
                    echo $this->Form->input('sendEmail', array(
                        'type' => "checkbox",
                        'default' => false,
                        'label' => false,
                        "div" => false,
                        "class" => "onoffswitch-checkbox"
                        , "id" => "email"
                    ));
                    ?>
                    <label class="onoffswitch-label" for="email">
                        <span class="onoffswitch-inner"></span>
                        <span class="onoffswitch-switch"></span>
                    </label>
                </div>
            </div>


        </div>
        <div class="col-md-6"
             <fieldset>                        	
                     <?php
                     echo $this->Form->hidden('id', array('value' => $project_id));
                     ?>
                <div class="input">
                    <span class="bold">Margin characters for matching </span>
                    <div class="margin-input">
                        <?php
                        echo $this->Form->input('margin', array('type' => 'number', 'min' => 0,
                            'value' => 0,
                            'label' => false,
                            'data-slider-min' => "0",
                            'data-slider-max' => "20",
                            'data-slider-step' => "1",
                            'data-slider-value' => "0",
                            'class' => 'margin-slide form-control',
                            'data-slider-ticks-labels' => "['0', '5', '10', '15', '20']"
                        ));
                        ?>
                    </div>
                </div>
                <?php
                echo $this->Form->input('round', array('name' => 'round_A', 'id' => 'round_A'));
                echo $this->Form->hidden('round.name', array('id' => 'round_name_A', 'name' => 'round_name_A'));
                echo $this->Form->input('User', array('multiple' => false, 'name' => 'user_A', 'id' => 'user_A'));
                echo $this->Form->hidden('name', array('id' => 'user_name_A', 'name' => 'user_name_A'));
                echo $this->Form->input('round', array('name' => 'round_B', 'id' => 'round_B'));
                echo $this->Form->hidden('round.name', array('id' => 'round_name_B', 'name' => 'round_name_B'));
                echo $this->Form->input('User', array('multiple' => false, 'name' => 'user_B', 'id' => 'user_B'));
                echo $this->Form->hidden('name', array('id' => 'user_name_B', 'name' => 'user_name_B'));
                echo $this->Form->input('type', array('multiple' => true));
                ?>
            </fieldset>
            <?php
            echo $this->Form->submit('Submit', array('class' => 'btn btn-success'));
            ?>
        </div>
        <?php echo $this->Form->end(); ?>
    </div>
</div>

<?php
echo $this->Html->link(__('Empty'), array('controller' => 'projects', 'action' => 'confrontationDual'), array('id' => 'endGoTo', 'class' => "hidden"));
echo $this->Html->link(__('Empty'), array('controller' => 'projects', 'action' => 'getProgress', true), array('id' => 'goTo', 'class' => "hidden"));
echo $this->Html->link(__('Empty'), array('controller' => 'projects', 'action' => 'view', $project_id), array('id' => 'goToMail', 'class' => "hidden"));
