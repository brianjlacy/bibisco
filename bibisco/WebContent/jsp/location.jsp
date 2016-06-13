<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page import="com.bibisco.manager.LocaleManager"%>
<%@ taglib prefix="fmt" uri="/jstl/fmt"%>
<%@ taglib prefix="c" uri="/jstl/core"%>
<%@ taglib prefix="fn" uri="/jstl/functions"%>
<fmt:setLocale value="<%=LocaleManager.getInstance().getLocale().toString()%>"/>

<script type="text/javascript">
//<![CDATA[
          
    var bibiscoRichTextEditor;    
     
    <!-- INIT DIALOG CALLBACK -->
    function bibiscoLocationInitCallback(ajaxDialog, idCaller, type, id, config) {
    	 
    	var bibiscoTaskStatusSelector;
    	var location = ${location};
    	
    	// id location
    	$('#bibiscoLocationIdLocation').val(location.idLocation);
    	

		//task status
    	bibiscoTaskStatusSelector = bibiscoTaskStatusSelectorInit({value: location.taskStatus, changeCallback: function() { bibiscoRichTextEditor.unSaved = true; } });
		
		//rich text editor height
		var bibiscoRichTextEditorVerticalPadding = 220;
		var bibiscoRichTextEditorHeight = ajaxDialog.getHeight() - bibiscoRichTextEditorVerticalPadding;
		
		bibiscoRichTextEditor = bibiscoRichTextEditorInit({
			text: location.description, 
			height: bibiscoRichTextEditorHeight, 
			width: jsBibiscoRichTextEditorWidth, 
			save: {
				idCaller: idCaller,
				action: 'saveLocation',
				id: location.idLocation,
	  			taskStatusSelector: bibiscoTaskStatusSelector,
		  		taskStatusToUpdate: true
			}
		});
		bibiscoRichTextEditor.unSaved = false;
		
    	// save button
    	$('#bibiscoLocationASave').click(function() {
    		bibiscoRichTextEditor.save();
    	});	  
    	$('#bibiscoLocationASave').tooltip();
    	
    	// close button
    	$('#bibiscoLocationAClose').tooltip();
    	
		// update title scene button
    	$('.ui-dialog-title').attr('id', 'bibiscoLocationDialogTitle');
    	bibiscoLocationButtonUpdateTitleInit(config, location.idLocation, location.position);
    	
    	// images button
    	$('#bibiscoLocationAImages').tooltip();
    	$('#bibiscoLocationAImages').click(function() {
    		var ajaxDialogContent = { 
  				  idCaller: 'bibiscoLocationDivImages',
  				  url: 'BibiscoServlet?action=openCarouselImage&idElement='+id+'&elementType=LOCATIONS',	    
  				  title: "<fmt:message key="jsp.carouselImage.dialog.title" /> " +location.name + " (" + location.fullyQualifiedArea + ")", 
  				  init: function (idAjaxDialog, idCaller) { return bibiscoCarouselImageInitCallback(idAjaxDialog, idCaller); },
  				  close: function (idAjaxDialog, idCaller) { return bibiscoCarouselImageCloseCallback(idAjaxDialog, idCaller); },
  				  beforeClose: function (idAjaxDialog, idCaller) { return bibiscoCarouselImageBeforeCloseCallback(idAjaxDialog, idCaller); },
  				  resizable: false, modal: true, 
  				  width: 810, height: 650, positionTop: 40
      		};

   
    		bibiscoOpenAjaxDialog(ajaxDialogContent);
   
    	});
    	
    	

    	
    }     
        
    function bibiscoLocationButtonUpdateTitleInit(config, idLocation, position) {
    	
    	$('#bibiscoLocationDialogTitle').append("&nbsp;<button id=\"bibiscoLocationButtonUpdateTitle\" title=\"<fmt:message key="jsp.location.button.updateTitle" />\" class=\"btn btn-mini\"><i class=\"icon-pencil\"></i></button>");
    	$('#bibiscoLocationButtonUpdateTitle').tooltip();
    	$('#bibiscoLocationButtonUpdateTitle').click(function() {
    		var ajaxDialogContent = { 
  				  idCaller: 'bibiscoLocationsACreateLocation',
  				  url: 'BibiscoServlet?action=startUpdateLocationTitle&position='+position+'&idLocation='+idLocation,
  				  title: "<fmt:message key="jsp.locations.dialog.title.changeThumbnailTitle" />", 
  				  init: function (idAjaxDialog, idCaller) { return bibiscoThumbnailTitleFormInit(idAjaxDialog, idCaller, config); },
  				  close: function (idAjaxDialog, idCaller) { return bibiscoThumbnailTitleFormClose(idAjaxDialog, idCaller); },
  				  beforeClose: function (idAjaxDialog, idCaller) { return bibiscoThumbnailTitleFormBeforeClose(idAjaxDialog, idCaller); },
  				  resizable: false, modal: true, 
  				  width: 500, height: 430, positionTop: 100
  		  };
  		  
  		  bibiscoOpenAjaxDialog(ajaxDialogContent);
    	});
    }
    
 	// close dialog callback
	function bibiscoLocationCloseCallback(ajaxDialog, idCaller, type) {
		bibiscoRichTextEditor.close();
		$('#bibiscoLocationAClose').tooltip('hide');
    }
	
	// before close dialog callback
	function bibiscoLocationBeforeCloseCallback(ajaxDialog, idCaller, type) {
		
		$('#bibiscoLocationAClose').tooltip('hide');
		if (bibiscoRichTextEditor.unSaved) {
			bibiscoRichTextEditorSpellCheck(bibiscoRichTextEditor, true);
			bibiscoConfirm(jsCommonMessageConfirmExitWithoutSave, function(result) {
			    if (result) {
			    	bibiscoRichTextEditor.unSaved = false;
			    	ajaxDialog.close();
			    } 
			});
			return false;
		} else {
			return true;	
		}

    }
	
	
	
//]]>           
</script>


<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>

<input type="hidden" id="bibiscoLocationIdLocation" />
<div class="bibiscoDialogContent">
	<tags:bibiscoRichTextEditor />
</div>
<div class="bibiscoDialogFooter control-group">
	<table>
		<tr>
			<td><tags:bibiscoTaskStatusSelector/></td>
			<td> 
				<a id="bibiscoLocationAImages" title="<fmt:message key="jsp.location.button.images" />" class="btn" href="#"><i class="icon-picture"></i></a> 
				<a id="bibiscoLocationASave" title="<fmt:message key="jsp.common.button.save" />" class="btn btn-primary" href="#"><i class="icon-ok icon-white"></i></a> 
				<a id="bibiscoLocationAClose" title="<fmt:message key="jsp.common.button.close" />" class="btn ajaxDialogCloseBtn" href="#"><i class="icon-remove"> </i> </a>
			</td>
		</tr>
	</table>
</div>