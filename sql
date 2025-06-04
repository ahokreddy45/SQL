SELECT 
    l.loan_id, 
    l.provider_loan_id,
    r.outstanding_amount, 
    i.installment_amount, 
    ld.penal_due, 
    ld.bcc_amount,
    i.due_date, 
    i.processing_date, 
    i.status, 
    CASE 
        WHEN CAST(i.due_date AS DATE) = CAST(l.first_emi_at AS DATE) THEN i.pre_emi 
        ELSE 0 
    END AS pre_emi_adjustment
FROM 
    loans_loan l
JOIN 
    core_installments i ON l.loan_id = i.loan_id
JOIN 
    reports_latestloanvalues r ON r.loan_id = l.loan_id
JOIN 
    loans_loandata_latest ld ON ld.loan_id = l.loan_id
WHERE 
    i.status = 'open'
    AND l.repayment_role IN (1, 2)
    AND r.dpd_bucket IN (0, 1, 2)
    AND (
        CAST(i.due_date AS DATE) = DATE '2025-06-03'
        OR CAST(i.due_date AS DATE) = DATE '2025-06-05'
    )
    AND (
        CAST(r.first_unpaid_emi_at AS DATE) = CAST(i.due_date AS DATE)
        OR CAST(r.first_unpaid_emi_at AS DATE) = CAST(DATE_ADD('month', 1, i.due_date) AS DATE)
    );
