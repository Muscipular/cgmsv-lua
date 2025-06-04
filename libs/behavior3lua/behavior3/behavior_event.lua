---@enum BehaviorTreeEvent
local BehaviorTreeEvent = {
    INTERRUPTED = "treeInterrupted",           -- ��Ϊ�����ж�
    BEFORE_RUN = "beforeRunTree",              -- ��Ϊ����ʼִ��ǰ
    AFTER_RUN = "afterRunTree",                -- ��Ϊ��ִ����ɺ�
    AFTER_RUN_SUCCESS = "afterRunTreeSuccess", -- ��Ϊ��ִ�гɹ���
    AFTER_RUN_FAILURE = "afterRunTreeFailure", -- ��Ϊ��ִ��ʧ�ܺ�
}

return BehaviorTreeEvent
