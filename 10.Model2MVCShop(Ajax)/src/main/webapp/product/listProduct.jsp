<%@ page contentType="text/html; charset=euc-kr" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>
	<c:if test="${menu.equals('manage')}">
		상품관리
	</c:if>
	<c:if test="${!menu.equals('manage')}">
		상품 목록조회
	</c:if>
</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
function fncGetList(currentPage){
	$("#currentPage").val(currentPage)
	$("form").attr("method","POST").attr("actrion","product/listProduct?menu=${menu}").submit();
}

$(function(){
	$(".ct_list_pop td:not(:nth-child(3))").on("click", function(){
		var prodNo = $(this).parent().children().eq(1).text().trim();
		$.ajax({
			url : "/product/json/getProduct/"+prodNo,
			method : "GET",
			dataType : "json",
			headers : {
				"Accept" : "application/json",
				"Content-Type" : "application/json"
			},
			success:function(JSONData, status){
				
// //					Debug...
// 					alert(status);
// //					Debug...
// 					alert("JSONData : \n"+JSONData);
// 					alert(JSONData.regDateString);
					
				var displayValue = "<h3>"
											+"상품번호 : "+JSONData.prodNo+"<br/>"
											+"상 품 명  : "+JSONData.prodName+"<br/>"
											+"이 미 지  : "+JSONData.fileName+"<br/>"
											+"등 록 일  : "+JSONData.regDateString+"<br/>"
											+"</h3>";
				
				$("h3").remove();
				$("#"+prodNo+"").html(displayValue);
			}
		});
		
	});
});

</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

<form name="detailForm" >

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37">
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">
						<c:if test="${menu.equals('manage')}">
							상품관리
						</c:if>
						<c:if test="${!menu.equals('manage')}">
							상품 목록조회
						</c:if>
					</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37">
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="right">
			<select name="searchCondition" class="ct_input_g" style="width:80px">
				<option value = "0" ${!empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>상품번호</option>
				<option value = "1" ${!empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>상품명</option>
				<option value = "2" ${!empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>상품가격</option>
			</select>
			<input 	type="text" name="searchKeyword"  value="${!empty search.searchKeyword ? search.searchKeyword : "" }" 
							class="ct_input_g" style="width:200px; height:19px" >
		</td>

		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						<a href="javascript:fncGetList(1);">검색</a>
					</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td colspan="11" >
		전체  ${resultPage.totalCount} 건수, 현재 ${resultPage.currentPage} 페이지</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">등록일</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">현재상태</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	
		<c:forEach var="product" items="${list }"  varStatus="status">
			<tr class="ct_list_pop">
				<td align="center">${status.count}</td>
				<td><p hidden>${product.prodNo }</p></td>
				<td align="left">
					<c:if test = "${product.proTranCode eq '0' || empty product.proTranCode}">
						<a href="/product/getProduct?prodNo=${product.prodNo }&menu=${menu}">${product.prodName }</a>
					</c:if>
					<c:if test = "${!empty product.proTranCode && product.proTranCode ne '0' }">
						${product.prodName }
					</c:if>
				</td>
				<td></td>
				<td align="left">${product.price }</td>
				<td></td>
				<td align="left">${product.regDate }</td>
				<td></td>
				<td align="left">
					<c:if test="${empty user || user.role eq 'user'}">
						<c:choose>
							<c:when test="${empty product.proTranCode || product.proTranCode eq '0'}">
								판매중
							</c:when>
							<c:when test="${product.proTranCode ne '0' }">
								재고없음
							</c:when>
						</c:choose>
					</c:if>
					<c:if test="${!empty user && user.role ne 'user' }">
						<c:choose>
							<c:when test="${product.proTranCode eq '1'}">
								구매완료
								<c:if test="${menu eq 'manage' }">
									<a href="/purchase/updateTranCodeByProd?prodNo=${product.prodNo }&tranCode=2&currentPage=${ resultPage.currentPage}">배송하기</a>
								</c:if>
							</c:when>
							<c:when test="${product.proTranCode eq '2'}">
								배송중
							</c:when>
							<c:when test="${product.proTranCode eq '3'}">
								배송완료
							</c:when>
							<c:otherwise>
								판매중
							</c:otherwise>
						</c:choose>
					</c:if>							

				</td>
			</tr>
			<tr>
				<td id="${product.prodNo}" colspan="11" bgcolor="D6D7D6" height="1"></td>
			</tr>
		</c:forEach>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
			<input type="hidden" id="currentPage" name="currentPage" value=""/>
			<jsp:include page="../common/pageNavigator.jsp"/>	
    	</td>
	</tr>
</table>
<!--  페이지 Navigator 끝 -->
</form>
</div>

</body>
</html>